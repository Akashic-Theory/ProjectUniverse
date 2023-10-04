extends MeshInstance3D

@export var movement_speed: float = 2.0
@onready var agent: NavigationAgent3D = $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if agent.is_navigation_finished():
		return
	
	var movement_delta: float = movement_speed * delta
	var next_path_pos: Vector3 = agent.get_next_path_position()
	var new_velocity: Vector3 = (next_path_pos - global_position).normalized() * movement_delta
	
	global_position = global_position.move_toward(global_position + new_velocity, movement_delta)

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_released("world_click"):
		agent.target_position = position
