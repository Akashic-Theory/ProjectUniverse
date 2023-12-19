//
// Created by Patrick on 10/7/2023.
//
#pragma once

#include "godot_cpp/classes/node3d.hpp"
#include "godot_cpp/classes/mesh_instance3d.hpp"

class GraphicalUtility: public godot::Node3D {
    GDCLASS(GraphicalUtility, godot::Node3D);

private:
    static std::vector<godot::MeshInstance3D*> storedMeshes;
protected:
    static void _bind_methods();
public:
    static godot::MeshInstance3D* get_path_mesh(const godot::PackedVector3Array& path);
    static godot::MeshInstance3D* get_point_mesh(const godot::Vector3& pos);
};

