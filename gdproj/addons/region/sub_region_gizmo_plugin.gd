extends EditorNode3DGizmoPlugin

const SubRegionNode3D = preload("res://addons/region/sub_region_node_3d.gd")
const SubRegionGizmo = preload("res://addons/region/sub_region_gizmo.gd")

func _get_gizmo_name():
	return "SubRegion"

func _init():
	create_material("positive", Color.DEEP_SKY_BLUE)
	create_material("negative", Color.ORANGE_RED)
	create_handle_material("handles")

func _create_gizmo(node):
	if node is SubRegionNode3D:
		return SubRegionGizmo.new()
	
	return null
