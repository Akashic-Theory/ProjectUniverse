@tool
class_name SubRegion
extends Node3D

@export_enum("Positive", "Negative") var type: int = 0:
	set(val):
		type = val
		is_positive = (type == 0)
		update_gizmos()

#@export_range(3, 10) var num_vertices: int = 3
@export var vertices = PackedVector3Array():
	get:
		if vertices.size() < 3:
			vertices.resize(3)
		
		return vertices
	set(val):
		if val.size() < 3:
			return
		
		vertices = val
		update_gizmos()

# Boolean representing type
var is_positive: bool


func _ready():
	# Do not run _process in-game
	if !Engine.is_editor_hint():
		set_process(false)
	
	#update_vertices()


func _process(delta):
	pass
	#update_vertices()


#func update_vertices():
#	if vertices.size() != num_vertices:
#		vertices.resize(num_vertices)
#		update_gizmos()


func gizmo_raycast(camera: Camera3D, point: Vector2) -> Vector3:
	var space_state = get_world_3d().direct_space_state
	
	var from = camera.project_ray_origin(point)
	var to = from + camera.project_ray_normal(point) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collision_mask = 3
	
	var result = space_state.intersect_ray(query)
	
	return result["position"]
