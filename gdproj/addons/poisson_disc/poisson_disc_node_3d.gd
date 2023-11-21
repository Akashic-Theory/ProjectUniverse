extends Node3D
class_name PoissonDisc

# Disc radius
var r: float
# The amount of placement attempts perfromed around each point
const K: int = 5

# A grid point's domain is defined by multiples of r / sqrt(2), represented by side_length
# grid[0][0] = box with origin point representing globalBound.min,
# 	and other point representing globalBound.min + side_length
var side_length: float
var grid = null

var region: Region

# all_points stores all the generated points organized by the sub region they belong to
# all_points[0] represents the points within region.sub_regions[0]
@onready var all_points = []
@onready var active_points = []

func _init(_region: Region, _radius: float):
	region = _region
	r = _radius
	
	for i in range(region.sub_regions.size()):
		all_points.append([])
	
	# Divide the bounds of the region into a grid
	side_length = r / sqrt(2)
	var grid_offset = region.bounds.max - region.bounds.min
	var grid_bound_x = abs(ceili(grid_offset.x / side_length))
	var grid_bound_y = abs(ceili(grid_offset.y / side_length))
	
	# Instantiate the grid
	grid = []
	for x in range(grid_bound_x):
		grid.append([])
		for y in range(grid_bound_y):
			grid[x].append(null)

# The big boy function that generates and returns all_points
func generate_distribution():
	# Generate one starting point in each positive region
	for sub_region in region.sub_regions:
		if !sub_region.is_positive:
			continue
		
		var point: Vector2
		var found_valid = false
		var count = 0
		
		# Limit the amount of placement attempts to 20
		while !found_valid && count < 20:
			point = Vector2(randf_range(sub_region.bounds.min.x, sub_region.bounds.max.x),
							randf_range(sub_region.bounds.min.y, sub_region.bounds.max.y))
			
			var result = check_valid_point(point)
			if result > -1:
				add_new_point(point, result)
				found_valid = true
			
			count += 1


# Attempt to generate K points around the given point
func generate_points(base_point: Vector2):
	var new_points = []
	
	for i in range(K):
		# Random point in donut
		var radius = r * sqrt(randf() + 1)
		var theta = randf() * 2 * PI
		
		# Cartesian conversion
		var point = Vector2(base_point.x + (radius * cos(theta)),
							 base_point.y + (radius * sin(theta)))
		
		var result = check_valid_point(point)
		if result > -1:
			new_points.append(point)
			add_new_point(point, result)
	
	# If we weren't able to make any new points, de-activate this one
	if new_points.size() == 0:
		active_points.erase(base_point)

# Returns the index of the region the given point resides in,
# 	or -1 if the point is invalid
func check_valid_point(point: Vector2) -> int:
	var index = to_grid_index(point)
	
	var i0 = maxf(index.x - 1, 0)
	var i1 = minf(index.x + 2, grid.size())
	var j0 = maxf(index.y - 1, 0)
	var j1 = minf(index.y + 2, grid[0].size())
	
	# Check if the point is too close to any others
	for i in range(i0, i1):
		for j in range(j0, j1):
			if grid[i][j] != null && grid[i][j].distance_to(point) < r:
				return false
	
	return region.bounds.contains_point(point)


func add_new_point(point: Vector2, index: int):
	all_points[index].append(point)
	active_points.append(point)
	
	var i = to_grid_index(point)
	grid[i.x][i.y] = point

# Converts from a floating point to an index on the grid
func to_grid_index(point: Vector2) -> Vector2i:
	var i = floori(point.x - region.bounds.min.x) / side_length
	var j = floori(point.y - region.bounds.min.y) / side_length
	
	return Vector2i(i, j)
