extends Node2D

@onready var sprite = preload("res://sprites/placeholder.tscn")
@onready var line = Line2D.new()

@onready var point_generator = $PointGenerator

var points
var objects : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	points = point_generator.generate_distribution()
	
	for p in points:
		var object = sprite.instantiate() as Node2D
		object.position = p
		objects.append(object)
		add_child(object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed("end_turn"):
		points = point_generator.generate_distribution()
		
		if objects.size() < points.size():
			objects.resize(points.size())
			for i in range(points.size()):
				if objects[i] == null:
					objects[i] = sprite.instantiate() as Node2D
					add_child(objects[i])
		elif objects.size() > points.size():
			for i in range(objects.size() - points.size()):
				objects.pop_back().queue_free()
		
		for i in range(points.size()):
			objects[i].position = points[i]
