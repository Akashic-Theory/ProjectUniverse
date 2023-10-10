extends EditorNode3DGizmoPlugin

const RegionNode3D = preload("res://addons/region/region_node_3d.gd")
const RegionGizmo = preload("res://addons/region/region_gizmo.gd")

func _get_gizmo_name():
	return "Region"

func _init():
	create_material("main", Color.RED)
	create_handle_material("handles")

func _create_gizmo(node):
	if node is RegionNode3D:
		return RegionGizmo.new()
	
	return null
