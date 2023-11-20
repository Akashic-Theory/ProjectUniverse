@tool
class_name SubRegion
extends Node3D

@export_enum("Positive", "Negative") var type: int = 0:
	set(val):
		type = val
		update_gizmos()
@export var vertices = PackedVector3Array():
	get:
		if vertices.size() < 3:
			vertices.resize(3)
		
		return vertices
	set(val):
		if val.size() < 3:
			return
		
		vertices = val
		update_collision_shape()
		update_gizmos()
@onready var collider := $Area3D:
	get:
		if collider == null:
			collider = $Area3D
		return collider
@onready var collision_polygon := $Area3D/CollisionPolygon3D:
	get:
		#if collision_polygon == null:
			#collision_polygon = $Area3D/CollisionPolygon3D
		return collision_polygon
@onready var bounds : Bounds2D = find_bounds()

# Boolean representing type
var is_positive: bool:
	get:
		return (type == 0)

class Bounds2D:
	var min : Vector2
	var max : Vector2
	
	func _init(_min: Vector2, _max: Vector2):
		min = _min
		max = _max

func _get_configuration_warnings():
	var error: PackedStringArray
	
	var areas = find_children("", "Area3D")
	var colliders = find_children("", "CollisionPolygon3D")
	
	if areas.size() == 0:
		error.append("SubRegion has no Area3D to perform point checks against")
	
	if areas.size() != colliders.size():
		error.append("All Area3Ds must be defined by a single CollisionPolygon3D")
	
	return error


func update_collision_shape():
	if collision_polygon == null:
		return
	
	var new_polygon = collision_polygon.polygon
	
	if new_polygon.size() != vertices.size():
		new_polygon.resize(vertices.size())
	
	for i in range(0, vertices.size()):
		new_polygon[i] = Vector2(vertices[i].x, vertices[i].z)
	
	collision_polygon.polygon = new_polygon


func contains_point(point: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	point.y = global_position.y
	
	var query = PhysicsPointQueryParameters3D.new()
	query.position = point
	query.collide_with_areas = true
	query.collision_mask = 8
	
	var result = space_state.intersect_point(query)
	
	# Filter to find this object's collider
	var filtered = result.filter(func(val): return val["collider"] == collider)
	
	return !filtered.is_empty()


# Returns the rectangular bounds of the region
func find_bounds() -> Bounds2D:
	var polygon = collision_polygon.polygon
	var min : Vector2 = polygon[0]
	var max : Vector2 = polygon[0]
	
	# Yes it's unreadable, who cares
	for i in range(1, polygon.size()):
		if min.x > polygon[i].x:
			min.x = polygon[i].x
		elif max.x < polygon[i].x:
			max.x = polygon[i].x 
		
		if min.y > polygon[i].y:
			min.y = polygon[i].y
		elif max.y < polygon[i].y:
			max.y = polygon[i].y
	
	return Bounds2D.new(min, max)


func gizmo_raycast(camera: Camera3D, point: Vector2) -> Vector3:
	var space_state = get_world_3d().direct_space_state
	
	var from = camera.project_ray_origin(point)
	var to = from + camera.project_ray_normal(point) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collision_mask = 4
	
	var result = space_state.intersect_ray(query)
	
	return result["position"]
