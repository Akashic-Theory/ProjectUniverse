extends Camera3D

@export var pan_scale = 0.5
@export var zoom_scale = 0.5
@export var min_zoom = 5.0
@export var max_zoom = 25.0

@onready var is_panning = false

func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	# Camera Panning
	if event.is_action_pressed("pan_camera"):
		is_panning = true
	elif event.is_action_released("pan_camera"):
		is_panning = false
	
	if is_panning && event is InputEventMouseMotion:
		global_position += -Vector3(event.relative.x, 0, event.relative.y) * pan_scale
	
	# Zoom in/out
	if event.is_action_pressed("zoom_camera_in", true):
		global_position.y -= zoom_scale
		if global_position.y < min_zoom:
			global_position.y = min_zoom
	elif event.is_action_pressed("zoom_camera_out", true):
		global_position.y += zoom_scale
		if global_position.y > max_zoom:
			global_position.y = max_zoom
