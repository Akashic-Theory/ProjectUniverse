#pragma once

#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/editor_plugin.hpp>
#include <godot_cpp/classes/editor_node3d_gizmo_plugin.hpp>
#include<godot_cpp/classes/editor_undo_redo_manager.hpp>

#include "Region.h"

class RegionGizmoPlugin;

class RegionPlugin : public godot::EditorPlugin {
    GDCLASS(RegionPlugin, godot::EditorPlugin);
protected:
    static void _bind_methods();
private:
    godot::Ref<RegionGizmoPlugin> gizmoPlugin;
public:
    void _enter_tree() override;
    void _exit_tree() override;
};

class RegionGizmoPlugin : public godot::EditorNode3DGizmoPlugin {
    GDCLASS(RegionGizmoPlugin, godot::EditorNode3DGizmoPlugin);
    friend class RegionPlugin;
protected:
    static void _bind_methods();
private:
    godot::EditorUndoRedoManager* undoRedo;
    godot::Vector2 newVert;
    int32_t active_handle;
public:
    void init(godot::EditorUndoRedoManager* undoRedoManager);
    virtual bool _has_gizmo(godot::Node3D *for_node_3d) const;
    virtual void _redraw(const godot::Ref<godot::EditorNode3DGizmo> &gizmo);
    virtual godot::String _get_gizmo_name();
    virtual godot::Variant _get_handle_value(const godot::Ref<godot::EditorNode3DGizmo> &gizmo,
                                             int32_t handle_id, bool secondary) const;
    virtual void _set_handle(const godot::Ref<godot::EditorNode3DGizmo> &gizmo,
                             int32_t handle_id, bool secondary,
                             godot::Camera3D *camera, const godot::Vector2 &screen_pos);
    virtual void _commit_handle(const godot::Ref<godot::EditorNode3DGizmo> &gizmo,
                                int32_t handle_id, bool secondary,
                                const godot::Variant &restore, bool cancel);
};
