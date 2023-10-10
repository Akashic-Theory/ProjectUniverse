extends EditorNode3DGizmo

var undo_redo := UndoRedo.new()

func _redraw():
	clear()
	
	var sub_region := get_node_3d() as SubRegion
	
	var lines = PackedVector3Array()
	var handles = PackedVector3Array()
	
	handles.push_back(sub_region.vertices[0])
	lines.push_back(sub_region.vertices[0])
	for v in range(1, sub_region.vertices.size()):
		handles.push_back(sub_region.vertices[v])
		lines.push_back(sub_region.vertices[v])
		lines.push_back(sub_region.vertices[v])
	lines.push_back(sub_region.vertices[0])
	
	
	var material = get_plugin().get_material("positive" if sub_region.is_positive else "negative", self)
	add_lines(lines, material, false)
	
	var handles_material = get_plugin().get_material("handles", self)
	add_handles(handles, handles_material, [])


func _get_handle_name(id, secondary):
	return ""


func _get_handle_value(id, secondary) -> Variant:
	#print("Handle id: ", id)
	return get_node_3d().vertices[id]


#func _is_handle_highlighted(id, secondary) -> bool:
#	pass


# Set handle's value
func _set_handle(id, secondary, camera, point):
	get_node_3d().vertices[id] = get_node_3d().gizmo_raycast(camera, point) - get_node_3d().position
	get_node_3d().notify_property_list_changed()
	get_node_3d().update_gizmos()
	#print(get_node_3d().vertices[id])


# Commit using undo/redo
func _commit_handle(id, secondary, restore, cancel):
	var sub_region = get_node_3d()
	
	if cancel:
		sub_region.vertices[id] = restore
		return
	
	var old_vertices = sub_region.vertices.duplicate()
	old_vertices[id] = restore
	
	undo_redo.create_action("Move Handle")
	undo_redo.add_do_property(get_node_3d(), "vertices", sub_region.vertices.duplicate())
	undo_redo.add_undo_property(get_node_3d(), "vertices", old_vertices)
	undo_redo.commit_action()
