//
// Created by Patrick on 10/7/2023.
//

#include "godot_cpp/classes/mesh_instance3d.hpp"
#include "godot_cpp/classes/immediate_mesh.hpp"
#include "godot_cpp/classes/sphere_mesh.hpp"
#include "godot_cpp/classes/orm_material3d.hpp"
#include "godot_cpp/classes/scene_tree.hpp"
#include <godot_cpp/variant/utility_functions.hpp>

#include "util/GraphicalUtility.h"

godot::ORMMaterial3D* GraphicalUtility::pathMaterial;

void GraphicalUtility::initialize_resources() {
    pathMaterial = memnew(godot::ORMMaterial3D);
    pathMaterial->set_shading_mode(godot::BaseMaterial3D::SHADING_MODE_UNSHADED);
    pathMaterial->set_albedo(godot::Color::named("Aquamarine"));
}

godot::MeshInstance3D* GraphicalUtility::get_path_mesh(const godot::PackedVector3Array& path) {
    godot::MeshInstance3D* meshInstance = memnew(godot::MeshInstance3D);
    godot::ImmediateMesh* immediateMesh = memnew(godot::ImmediateMesh);
//    godot::ORMMaterial3D* material = memnew(godot::ORMMaterial3D);

    meshInstance->set_mesh(immediateMesh);
    meshInstance->set_cast_shadows_setting(godot::GeometryInstance3D::SHADOW_CASTING_SETTING_OFF);

    immediateMesh->surface_begin(godot::Mesh::PRIMITIVE_LINE_STRIP, pathMaterial);

    for (auto& pos: path) {
        immediateMesh->surface_add_vertex(pos);
    }

    immediateMesh->surface_end();

//    material->set_shading_mode(godot::BaseMaterial3D::SHADING_MODE_UNSHADED);
//    material->set_albedo(godot::Color::named("Aquamarine"));

    return meshInstance;
}

bool GraphicalUtility::update_path_mesh(godot::MeshInstance3D* meshInstance, const godot::PackedVector3Array& path) {
    if (!meshInstance || path.size() < 2) {
        return false;
    }
    godot::Vector3 offset = path[0];

    godot::ImmediateMesh* immediateMesh = (godot::ImmediateMesh*) (*meshInstance->get_mesh());
//    godot::Material* material = *immediateMesh->_surface_get_material(0);

    immediateMesh->clear_surfaces();
    immediateMesh->surface_begin(godot::Mesh::PRIMITIVE_LINE_STRIP, pathMaterial);

    for (auto& pos: path) {
        immediateMesh->surface_add_vertex(pos - offset);
    }

    immediateMesh->surface_end();

    return true;
}

godot::MeshInstance3D* GraphicalUtility::get_point_mesh(const godot::Vector3 &pos) {
    godot::MeshInstance3D* meshInstance = memnew(godot::MeshInstance3D);
    godot::SphereMesh* sphereMesh = memnew(godot::SphereMesh);
    godot::ORMMaterial3D* material = memnew(godot::ORMMaterial3D);

    meshInstance->set_mesh(sphereMesh);
    meshInstance->set_cast_shadows_setting(godot::GeometryInstance3D::SHADOW_CASTING_SETTING_OFF);
    meshInstance->set_global_position(pos);

    sphereMesh->set_radius(0.2);
    sphereMesh->set_height(0.4);
    sphereMesh->set_material(material);

    material->set_shading_mode(godot::BaseMaterial3D::SHADING_MODE_UNSHADED);
    material->set_albedo(godot::Color::named("VIOLET"));

    return meshInstance;
}

void GraphicalUtility::_bind_methods() {
    using namespace godot;

    initialize_resources();

    ClassDB::bind_static_method(GraphicalUtility::get_class_static(),
                                D_METHOD("path_mesh", "path"),
                                &GraphicalUtility::get_path_mesh);
    ClassDB::bind_static_method(GraphicalUtility::get_class_static(),
                                D_METHOD("update_path_mesh", "meshInstance", "path"),
                                &GraphicalUtility::update_path_mesh);
    ClassDB::bind_static_method(GraphicalUtility::get_class_static(),
                                D_METHOD("point_mesh", "pos"),
                                &GraphicalUtility::get_point_mesh);
}