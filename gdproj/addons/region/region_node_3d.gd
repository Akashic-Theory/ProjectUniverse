@tool
class_name Region
extends Node3D

var sub_regions: Array


func _ready():
	sub_regions = find_children("", "SubRegion", false)


func _get_configuration_warnings():
	var error: PackedStringArray
	
	var areas = find_children("", "Area3D")
	
	if areas.size() == 0:
		error.append("Region has no Area3D to perform gizmo raycasts against")
	
	return error


func contains_point(point: Vector3) -> bool:
	var result = false
	
	for r in sub_regions:
		if r.contains_point(point):
			if r.is_positive:
				result = true
			else:
				result = false
				break
	
	return result


func _on_projection_plane_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_pressed("click"):
		print(contains_point(position))
