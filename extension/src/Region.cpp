#include "Region.h"

namespace {
    constexpr double SKIN = 1;
}

/******************************************************************************
 *************************         Sub Region         *************************
 ******************************************************************************/

void SubRegion::recalc_bounds() {
    if (vertices.size() < 3) {
        // Not a valid subregion, ignore recalc
        return;
    }
    godot::Vector2 begin, end;
    begin = end = vertices[0];
    for (int i = 1; i < vertices.size(); ++i) {
        if (vertices[i].x < begin.x)
            begin.x = vertices[i].x;
        if (vertices[i].y < begin.y)
            begin.y = vertices[i].y;
        if (vertices[i].x > end.x)
            begin.x = vertices[i].x;
        if (vertices[i].y > end.y)
            begin.y = vertices[i].y;
    }
    bounds.position = begin;
    bounds.set_end(end);
    emit_signal("bounds_updated", bounds);
}

bool SubRegion::contains_point(const godot::Vector2& point) {
    if (vertices.size() < 3) {
        // Not enough points for a polygon
        return false;
    }

    // Run ray-intersection algorithm
    size_t intersections = 0;
    godot::Vector2 lastVert = vertices[vertices.size() - 1];
    for (const auto& curVert: vertices) {
        real_t ratio = (curVert.y - point.y) / (curVert.y - lastVert.y);
        if (ratio < 0 || ratio >= 1 || point.x < ((curVert.x - lastVert.x) * ratio)) {
            lastVert = curVert;
            continue;
        }
        lastVert = curVert;
        intersections++;
    }
    return intersections % 2;
}

godot::PackedVector2Array SubRegion::get_vertices() const {
    return vertices;
}

void SubRegion::set_vertices(const godot::PackedVector2Array& verts) {
    vertices = verts;
    recalc_bounds();
}

godot::PackedStringArray SubRegion::_get_configuration_warnings() const {
    godot::PackedStringArray error;
    if (vertices.size() < 3) {
        error.append("SubRegion must consist of at least 3 points!");
    }
    return error;
}

void SubRegion::_bind_methods() {
    using namespace godot;
    ADD_SIGNAL(MethodInfo("bounds_updated", PropertyInfo(Variant::RECT2, "bounds")));

    ClassDB::bind_method(D_METHOD("get_vertices"), &SubRegion::get_vertices);
    ClassDB::bind_method(D_METHOD("set_vertices", "vertices"), &SubRegion::set_vertices);
    ADD_PROPERTY(PropertyInfo(Variant::PACKED_VECTOR2_ARRAY, "vertices"), "set_vertices", "get_vertices");
}

/******************************************************************************
 *************************           Region           *************************
 ******************************************************************************/

void Region::recalc_bounds() {
    godot::Vector3 pos = get_global_position();
    bounds = godot::Rect2(pos.x, pos.y, 0, 0);
    for (const auto& subRegion: subRegions) {
        bounds = bounds.merge(subRegion->bounds);
    }
    emit_signal("bounds_updated", bounds);
}

godot::Rect2 Region::get_bounds() {
    return bounds;
}

SubRegion* Region::containing_subregion(const godot::Vector2& point,
                                        const godot::PackedStringArray& required_tags,
                                        const godot::PackedStringArray& prohibited_tags) const {
    for (const auto& subRegion: subRegions) {
        // Ugly quick and dirty nested iteration to test with strings. TODO: refactor with flags
        if ([&]() {
            for (const auto& tag: required_tags) {
                if (!subRegion->tags.has(tag)) {
                    // Missing a required tag
                    return false;
                }
            }
            for (const auto& tag: subRegion->tags) {
                if (prohibited_tags.has(tag)) {
                    // Tag is in the prohibited list
                    return false;
                }
            }
            return true;
        }() && subRegion->contains_point(point)) {
            return subRegion;
        }
    }
    return nullptr;
}

godot::PackedStringArray Region::_get_configuration_warnings() const {
    godot::PackedStringArray error;
    //TODO: Config check
    return error;
}

void Region::_bind_methods() {
    using namespace godot;
    static godot::PackedStringArray empty_tags;

    ADD_SIGNAL(MethodInfo("bounds_updated", PropertyInfo(Variant::RECT2, "bounds")));

    ClassDB::bind_method(D_METHOD("containing_subregion", "point", "required_tags", "prohibited_tags"),
                         &Region::containing_subregion,
                         DEFVAL(empty_tags), DEFVAL(empty_tags));
}
