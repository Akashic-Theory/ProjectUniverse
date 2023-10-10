@tool
extends EditorPlugin

const GizmoPlugin = preload("res://addons/region/region_gizmo_plugin.gd")

var gizmo_plugin = GizmoPlugin.new()

func _enter_tree():
	add_custom_type("Region", "Node3D", preload("region_node_3d.gd"), null)
	add_node_3d_gizmo_plugin(gizmo_plugin)

func _exit_tree():
	remove_custom_type("Region")
	remove_node_3d_gizmo_plugin(gizmo_plugin)
