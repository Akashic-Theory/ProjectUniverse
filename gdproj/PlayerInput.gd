class_name PlayerInput
extends Character

@export var movement_speed: float = 2.0
@export var max_movement: float = 4.0
@export var hover_material: Material = null

@onready var agent := $NavigationAgent3D
@onready var mesh := $Mesh
var path_mesh : MeshInstance3D

@onready var is_turn := true
@onready var is_selected := false
@onready var is_moving := false

var id: int # The character's unique ID
signal selected(id: int, status: bool)

func _physics_process(delta):
	if path_mesh != null:
		path_mesh.queue_free()
	
	if agent.is_navigation_finished():
		is_moving = false
		return
	
	if !is_moving:
		# Draw path
		var trimmed_path = Pathfinding.trim_path(agent.get_current_navigation_path(), max_movement)
		agent.target_position = trimmed_path[-1]
		trimmed_path = Pathfinding.localize_path(trimmed_path)
		path_mesh = GraphicalUtility.path_mesh(trimmed_path)
#		get_tree().get_root().add_child(path_mesh)
		add_child(path_mesh)
	else:
		# Move along path
		var movement_delta: float = movement_speed * delta
		var next_path_pos: Vector3 = agent.get_next_path_position()
		var new_velocity: Vector3 = (next_path_pos - global_position).normalized() * movement_delta
		global_position = global_position.move_toward(global_position + new_velocity, movement_delta)

# Logic for path previews and movement input
func _on_terrain_hover(camera, event, position, normal, shape_idx):
	if is_turn && is_selected && !is_moving:
		if event.is_action_pressed("start_move"):
			is_moving = true
			return
		
		if Input.is_action_pressed("move_hover"):
			agent.target_position = position
		else:
			agent.target_position = global_position

# Swaps the mesh material when hovered
func _on_mouse_entered():
	if is_turn:
		mesh.set_surface_override_material(0, hover_material)

func _on_mouse_exited():
	if !is_selected:
		mesh.set_surface_override_material(0, null)

# Player clicked on me!
func _on_input_event(camera, event, position, normal, shape_idx):
	if is_turn && event.is_action_pressed("click"):
		is_selected = !is_selected
		selected.emit(id, is_selected)

func change_turn(state: bool):
	is_turn = state
	
	if !state:
		is_selected = false
		mesh.set_surface_override_material(0, null)
