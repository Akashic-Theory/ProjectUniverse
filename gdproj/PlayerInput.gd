class_name PlayerInput
extends Character

@onready var agent := $NavigationAgent3D
var path_mesh : MeshInstance3D

## Returns a trimmed version of the navigation agent's current path
## Unless the character is moving, in which case it simply returns the last set value
@onready var current_path := PackedVector3Array():
	get:
		if is_moving():
			return current_path
		if Pathfinding.count_path(agent.get_current_navigation_path()) > remaining_movement:
			current_path = Pathfinding.trim_path(agent.get_current_navigation_path(), remaining_movement)
		else:
			current_path = agent.get_current_navigation_path()
		return current_path
	set(value):
		current_path = value

var next_path_index : int

signal move_completed()

func _ready():
	remaining_movement = max_movement
	
	path_mesh = GraphicalUtility.path_mesh(current_path)
	add_child(path_mesh)
	path_mesh.position = Vector3.ZERO

func _physics_process(delta):
	if !Input.is_action_pressed("move_hover"):
		path_mesh.mesh.clear_surfaces()
		pass
	
	# As long as we are supposed to be moving and the path is valid...
	if is_moving() && current_path.size() > 1:
		var movement_delta: float = speed * delta
		var next_path_pos = current_path[next_path_index]
		global_position = global_position.move_toward(next_path_pos, movement_delta)
		
		# If we reached a checkpoint, move to the next one or quit
		if global_position.distance_squared_to(next_path_pos) == 0:
			next_path_index += 1
		if current_path.size() == next_path_index:
			move_completed.emit()


func draw_move_path():
	# Forcing the agent to calculate the path
	agent.get_next_path_position()
	if current_path.size() < 2:
		return
	
	GraphicalUtility.update_path_mesh(path_mesh, current_path)


func start_movement():
	# Free the path preview
	path_mesh.mesh.clear_surfaces()
	
	next_path_index = 1
	start_moving()
	
	# Update remaining movement
	remaining_movement -= Pathfinding.count_path(current_path)

