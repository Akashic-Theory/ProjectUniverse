#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include "godot_cpp/classes/camera3d.hpp"

class SubRegion : public godot::Node3D {
    GDCLASS(SubRegion, godot::Node3D);
    friend class Region;
    friend class RegionGizmoPlugin;
protected:
    static void _bind_methods();
private:
    godot::Rect2 bounds;
    godot::PackedStringArray tags;
    godot::PackedVector2Array vertices;

    void recalc_bounds();
    godot::Vector3 gizmo_raycast(godot::Camera3D* camera, godot::Vector2 point) const;
public:
    godot::PackedVector2Array get_vertices() const;
    void set_vertices(const godot::PackedVector2Array& verts);
    bool contains_point(const godot::Vector2& point);

    [[nodiscard]] godot::PackedStringArray _get_configuration_warnings() const;
};

class Region : public godot::Node3D {
    GDCLASS(Region, godot::Node3D);
private:
    std::vector<SubRegion*> subRegions;
    godot::Rect2 bounds;

    void recalc_bounds();
protected:
    static void _bind_methods();
public:
    godot::Rect2 get_bounds();
    SubRegion* containing_subregion(const godot::Vector2& point,
                                    const godot::PackedStringArray& required_tags,
                                    const godot::PackedStringArray& prohibited_tags) const;

    [[nodiscard]] godot::PackedStringArray _get_configuration_warnings() const;
};
