@tool
extends EditorPlugin

const PoissonDiscGizmoPlugin = preload("res://addons/poisson_disc/poisson_disc_gizmo_plugin.gd")

var poisson_disc_gizmo_plugin = PoissonDiscGizmoPlugin.new()

func _enter_tree():
	add_custom_type("PoissonDisc", "Node3D", preload("poisson_disc_node_3d.gd"), null)
	
	add_node_3d_gizmo_plugin(poisson_disc_gizmo_plugin)


func _exit_tree():
	remove_custom_type("PoissonDisc")
	
	remove_node_3d_gizmo_plugin(poisson_disc_gizmo_plugin)
