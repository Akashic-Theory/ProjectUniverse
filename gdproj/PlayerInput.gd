class_name PlayerInput
extends Character

@onready var agent := $NavigationAgent3D
var path_mesh : MeshInstance3D

signal selected()

func _physics_process(delta):
	#print(Input.is_action_pressed("move_hover"))
	
	if path_mesh != null:
		path_mesh.queue_free()
	
	if agent.is_navigation_finished():
		return
	
	if !is_moving():
		# Draw path
		var trimmed_path = Pathfinding.trim_path(agent.get_current_navigation_path(), max_movement)
		agent.target_position = trimmed_path[-1]
		path_mesh = GraphicalUtility.path_mesh(trimmed_path)
		add_child(path_mesh)
		path_mesh.position -= trimmed_path[0]
	else:
		# Move along path
		var movement_delta: float = speed * delta
		remaining_movement -= movement_delta
		print(remaining_movement)
		var next_path_pos: Vector3 = agent.get_next_path_position()
		global_position = global_position.move_toward(next_path_pos, movement_delta)
