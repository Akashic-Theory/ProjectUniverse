extends Node2D

## Points will be placed up to this distance away from the center
@export var bounds_radius = 10
## The distance apart that points will be placed
@export var r = 2.0
## The amount of points the algorithm will attempt to generate each step
const K : int = 7

@onready var side_length = r / sqrt(2)
@onready var grid = []

@onready var all_points = PackedVector2Array()
@onready var active_points = PackedVector2Array()
#@onready var graph = {}

var grid_bound_x
var grid_bound_y

# Called when the node enters the scene tree for the first time.
func _ready():
	# Calculate grid size
	var grid_offset = Vector2.ONE * bounds_radius * 2
	grid_bound_x = absi(ceili(grid_offset.x / side_length))
	grid_bound_y = absi(ceili(grid_offset.y / side_length))

func generate_distribution() -> PackedVector2Array:
	all_points.clear()
	#graph.clear()
	
	# Initialize grid
	# All of its values are null
	grid = []
	grid.resize(grid_bound_x)
	#grid.fill([])
	for i in range(grid_bound_x):
		grid[i] = []
		grid[i].resize(grid_bound_y)
	
	# Generate a single starting point
	var radius = (bounds_radius - r) * sqrt(randf())
	var theta = randf() * TAU
	# To cartesian...
	var point = Vector2(radius * cos(theta), radius * sin(theta))
	
	add_new_point(point)
	
	# Main loop
	while(active_points.size() > 0):
		#prints(active_points.size(), all_points.size())
		generate_points(active_points[randi_range(0, active_points.size() - 1)])
	
	return all_points


## Attempt to generate K points around a base point
func generate_points(base_point : Vector2):
	var new_points_count = 0
	
	for i in range(K):
		# Random point in a donut
		var radius = r * (sqrt(randf()) + 1)
		var theta = randf() * TAU
		# To cartesian...
		var point = Vector2(base_point.x + (radius * cos(theta)), 
				base_point.y + (radius * sin(theta)))
		
		if check_valid_point(point):
			new_points_count += 1
			add_new_point(point)
	
	# If no new points were generated, de-activate the base point
	if new_points_count == 0:
		active_points.remove_at(active_points.find(base_point))


func check_valid_point(point : Vector2):
	var index = to_grid_index(point)
	
	var x0 = maxi(index.x - 1, 0)
	var x1 = mini(index.x + 1, grid.size() - 1)
	var y0 = maxi(index.y - 1, 0)
	var y1 = mini(index.y + 1, grid[0].size() - 1)
	
	# Check for points that are too close
	for i in range(x0, x1 + 1):
		for j in range(y0, y1 + 1):
			if grid[i][j] != null and point.distance_to(grid[i][j]) < r:
				return false
	
	# Check if the point is outside the valid domain
	if point.length_squared() > pow(bounds_radius, 2):
		return false
	
	return true


func add_new_point(point : Vector2):
	all_points.append(point)
	active_points.append(point)
	
	# Assign to the grid
	var index = to_grid_index(point)
	grid[index.x][index.y] = point


func to_grid_index(point : Vector2) -> Vector2i:
	var x = absi(floori((point.x + bounds_radius) / side_length))
	var y = absi(floori(absf(point.y + bounds_radius) / side_length))
	
	return Vector2i(x, y)
