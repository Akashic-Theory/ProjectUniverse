@tool
class_name Region
extends Node3D
# TODO: Modify this node to instead hold subregions

@export_range(3, 10) var num_vertices: int
var vertices = PackedVector3Array()


func _get_configuration_warnings():
	var error: PackedStringArray
	
	var areas = find_children("", "Area3D")
	
	if areas.size() == 0:
		error.append("Region has no Area3D to perform gizmo raycasts against")
	
	return error


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if vertices.size() != num_vertices:
		print("resize")
		vertices.resize(num_vertices)


func gizmo_raycast(camera: Camera3D, point: Vector2) -> Vector3:
	var space_state = get_world_3d().direct_space_state
	
	var from = camera.project_ray_origin(point)
	var to = from + camera.project_ray_normal(point) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	
	return result["position"]
