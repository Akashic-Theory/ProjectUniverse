#include <godot_cpp/variant/color.hpp>
#include <godot_cpp/classes/standard_material3d.hpp>

#include "plugin/RegionPlugin.h"
#include "godot_cpp/variant/utility_functions.hpp"

namespace {
    inline godot::Vector3 toVec3(const godot::Vector2& vert, real_t y = 0) {
        return {vert.x, y, vert.y};
    }
    inline  godot::Vector2 toVec2(const godot::Vector3& vert) {
        return {vert.x, vert.z};
    }
}

/******************************************************************************
 *************************       Region Plugin        *************************
 ******************************************************************************/

void RegionPlugin::_bind_methods() {

}

void RegionPlugin::_enter_tree() {
    gizmoPlugin.instantiate();
    gizmoPlugin->init(get_undo_redo());
    add_node_3d_gizmo_plugin(gizmoPlugin);
}

void RegionPlugin::_exit_tree() {
    remove_node_3d_gizmo_plugin(gizmoPlugin);
}

/******************************************************************************
 *************************     Region Gizmo Plugin    *************************
 ******************************************************************************/

void RegionGizmoPlugin::_bind_methods() {
    using namespace godot;
}

void RegionGizmoPlugin::init(godot::EditorUndoRedoManager* undoRedoManager) {
    undoRedo = undoRedoManager;
    create_material("zone", godot::Color::named("DEEP_SKY_BLUE"));
    create_handle_material("handle");
}

bool RegionGizmoPlugin::_has_gizmo(godot::Node3D* for_node_3d) const {
    if (for_node_3d) {
        return for_node_3d->is_class(SubRegion::get_class_static());
    }
    return false;
}

void RegionGizmoPlugin::_redraw(const godot::Ref<godot::EditorNode3DGizmo> &gizmo) {
    gizmo->clear();

    SubRegion* target = cast_to<SubRegion>(gizmo->get_node_3d());
    if (!target) {
        ERR_PRINT("Attempted drawing gizmo without valid subregion target");
        return;
    }
    if (target->vertices.size() < 3) {
        target->vertices = {};
        target->vertices.push_back({-1, -0.5});
        target->vertices.push_back({1, -0.5});
        target->vertices.push_back({0, 1});
    }

    godot::PackedVector3Array lines;
    godot::PackedVector3Array handles;

    godot::Vector3 last = toVec3(target->vertices[target->vertices.size() - 1]);
    for (const auto& vert: target->vertices) {
        godot::Vector3 v3 = toVec3(vert);
        handles.push_back(v3);
        lines.push_back(last);
        lines.push_back(v3);
        last = v3;
    }

    auto material = get_material("zone", gizmo);
    gizmo->add_lines(lines, material);

    auto handleMaterial = get_material("handle", gizmo);
    gizmo->add_handles(handles, handleMaterial, {});
}

godot::String RegionGizmoPlugin::_get_gizmo_name() {
    return "Region Gizmo";
}
godot::Variant RegionGizmoPlugin::_get_handle_value(const godot::Ref<godot::EditorNode3DGizmo> &gizmo,
                                                    int32_t handle_id, bool secondary) const {
    SubRegion* target = cast_to<SubRegion>(gizmo->get_node_3d());
    if (!target) {
        ERR_PRINT("Encountered gizmo without valid subregion target");
        return {};
    }
    return toVec3(target->vertices[handle_id]);
}

void RegionGizmoPlugin::_set_handle(const godot::Ref<godot::EditorNode3DGizmo> &gizmo,
                                    int32_t handle_id, bool secondary,
                                    godot::Camera3D *camera, const godot::Vector2 &screen_pos) {
    SubRegion* target = cast_to<SubRegion>(gizmo->get_node_3d());
    if (!target) {
        ERR_PRINT("Encountered gizmo without valid subregion target");
        return;
    }

    godot::Vector3 hit = target->gizmo_raycast(camera, screen_pos) - target->get_position();
    target->vertices[handle_id] = toVec2(hit);
    target->notify_property_list_changed();
    target->update_gizmos();
}

void RegionGizmoPlugin::_commit_handle(const godot::Ref<godot::EditorNode3DGizmo> &gizmo,
                                       int32_t handle_id, bool secondary,
                                       const godot::Variant &restore, bool cancel) {
    SubRegion* target = cast_to<SubRegion>(gizmo->get_node_3d());
    if (!target) {
        ERR_PRINT("Encountered gizmo without valid subregion target");
        return;
    }
    if (cancel) {
        target->vertices[handle_id] = toVec2(restore);
    }
    godot::PackedVector2Array oldVerts = target->vertices.duplicate();
    oldVerts[handle_id] = toVec2(restore);

    undoRedo->create_action("Move Handle");
    undoRedo->add_do_property(target, "vertices", target->vertices.duplicate());
    undoRedo->add_undo_property(target, "vertices", oldVerts);
    undoRedo->add_do_method(target, "update_gizmos");
    undoRedo->add_undo_method(target, "update_gizmos");
    undoRedo->commit_action();

}
