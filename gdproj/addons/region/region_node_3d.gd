@tool
class_name Region
extends Node3D

@onready var sub_regions := $SubRegion


func _get_configuration_warnings():
	var error: PackedStringArray
	
	var areas = find_children("", "Area3D")
	
	if areas.size() == 0:
		error.append("Region has no Area3D to perform gizmo raycasts against")
	
	return error
