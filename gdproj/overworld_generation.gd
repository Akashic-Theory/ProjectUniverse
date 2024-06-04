extends Node2D

@onready var sprite = preload("res://sprites/placeholder.tscn")
@onready var base_line = Line2D.new()

@export var proximity_mod = 1.0

@onready var point_generator = $PointGenerator

# TODO: Make a struct to store the points as map locations
var points
var graph
var visuals : Array
var lines : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	base_line.width = 2
	
	points = point_generator.generate_distribution()
	graph = point_generator.generate_proximity_graph(proximity_mod)
	
	for p in points:
		# Place the sprite
		var visual = sprite.instantiate() as Node2D
		visual.position = p
		visuals.append(visual)
		add_child(visual)
		
		# Draw lines
		# (this will end up drawing 2 identical lines 
		# in a lot of cases but I don't care right now)
		for neighbor in graph[p]:
			var line = base_line.duplicate() as Line2D
			line.add_point(p)
			line.add_point(neighbor)
			lines.append(line)
			add_child(line)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed("end_turn"):
		points = point_generator.generate_distribution()
		graph = point_generator.generate_proximity_graph(proximity_mod)
		
		# Make more objects to match amount of points
		if visuals.size() < points.size():
			visuals.resize(points.size())
			for i in range(points.size()):
				if visuals[i] == null:
					visuals[i] = sprite.instantiate() as Node2D
					add_child(visuals[i])
		# Free objects to match amount of points
		elif visuals.size() > points.size():
			for i in range(visuals.size() - points.size()):
				visuals.pop_back().queue_free()
		
		# You know the smart object re-using we did above?
		# Yeah fuck that.
		for line in lines:
			line.queue_free()
		lines.clear()
		
		# Redraw with new information
		for i in range(points.size()):
			visuals[i].position = points[i]
			
			for neighbor in point_generator.graph[points[i]]:
				var line = base_line.duplicate() as Line2D
				line.add_point(points[i])
				line.add_point(neighbor)
				lines.append(line)
				add_child(line)
