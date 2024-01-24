//
// Created by Patrick on 10/7/2023.
//
#pragma once

#include <godot_cpp/classes/node3d.hpp>

class Pathfinding: public godot::Node3D {
    GDCLASS(Pathfinding, godot::Node3D);

protected:
    static void _bind_methods();
public:
    static godot::PackedVector3Array trim_path(const godot::PackedVector3Array& path, const double maxDistance);
    // TODO: fix this return, should be a godot::Variant::FLOAT but it won't let me do that
    static godot::Variant count_path(const godot::PackedVector3Array& path);
};

