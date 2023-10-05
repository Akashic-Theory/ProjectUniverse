class_name PlayerInput
extends MeshInstance3D

@export var movement_speed: float = 2.0
@export var hover_material: Material = null

@onready var agent: NavigationAgent3D = $NavigationAgent3D

@onready var is_turn: bool = false
@onready var is_selected: bool = false

var id: int # The character's unique ID
signal selected(id: int, status: bool)

func _physics_process(delta):
	if agent.is_navigation_finished():
		return
	
	var movement_delta: float = movement_speed * delta
	var next_path_pos: Vector3 = agent.get_next_path_position()
	var new_velocity: Vector3 = (next_path_pos - global_position).normalized() * movement_delta
	
	global_position = global_position.move_toward(global_position + new_velocity, movement_delta)

func _on_terrain_hover(camera, event, position, normal, shape_idx):
	if is_turn && is_selected && event.is_action_pressed("shift_click"):
		agent.target_position = position

# Swaps the mesh material when hovered
func _on_mouse_entered():
	if is_turn:
		set_surface_override_material(0, hover_material)

func _on_mouse_exited():
	if !is_selected:
		set_surface_override_material(0, null)

# Player clicked on me!
func _on_input_event(camera, event, position, normal, shape_idx):
	if is_turn && event.is_action_pressed("click"):
		is_selected = !is_selected
		selected.emit(id, is_selected)

func change_turn(state: bool):
	is_turn = state
	
	if !state:
		is_selected = false
		set_surface_override_material(0, null)
