@tool
extends EditorPlugin

#const RegionGizmoPlugin = preload("res://addons/region/region_gizmo_plugin.gd")
const SubRegionGizmoPlugin = preload("res://addons/region/sub_region_gizmo_plugin.gd")

#var region_gizmo_plugin = RegionGizmoPlugin.new()
var sub_region_gizmo_plugin = SubRegionGizmoPlugin.new()

func _enter_tree():
	add_custom_type("Region", "Node3D", preload("region_node_3d.gd"), null)
	add_custom_type("SubRegion", "Node3D", preload("sub_region_node_3d.gd"), null)
	#add_node_3d_gizmo_plugin(region_gizmo_plugin)
	add_node_3d_gizmo_plugin(sub_region_gizmo_plugin)

func _exit_tree():
	remove_custom_type("Region")
	remove_custom_type("SubRegion")
	#remove_node_3d_gizmo_plugin(region_gizmo_plugin)
	remove_node_3d_gizmo_plugin(sub_region_gizmo_plugin)
