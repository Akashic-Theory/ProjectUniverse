//
// Created by Patrick on 10/7/2023.
//
#pragma once

#include "godot_cpp/classes/node3d.hpp"
#include "godot_cpp/classes/mesh_instance3d.hpp"
#include "godot_cpp/classes/orm_material3d.hpp"

class GraphicalUtility: public godot::Node3D {
    GDCLASS(GraphicalUtility, godot::Node3D);

private:
//    static std::vector<godot::MeshInstance3D*> storedMeshes;
    static godot::ORMMaterial3D* pathMaterial;
protected:
    static void _bind_methods();
public:
    static void initialize_resources();
    static godot::MeshInstance3D* get_path_mesh(const godot::PackedVector3Array& path);
    static bool update_path_mesh(godot::MeshInstance3D* meshInstance, const godot::PackedVector3Array& path);
    static godot::MeshInstance3D* get_point_mesh(const godot::Vector3& pos);
};

