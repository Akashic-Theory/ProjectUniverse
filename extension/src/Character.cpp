#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/collision_object3d.hpp>

#include "Character.h"
#include "Ability.h"

Character::Character() {
    //godot::UtilityFunctions::print("Test");
}

Character::~Character() {

}

godot::PackedStringArray Character::_get_configuration_warnings() const {
    godot::PackedStringArray error;
    godot::TypedArray<Ability>  abilities = find_children("", "Ability");
    godot::TypedArray<godot::CollisionObject3D> colliders = find_children("", "CollisionObject3D");

    if (abilities.size() == 0) {
        error.append("Character has no abilities!");
    }

    if (colliders.size() == 0) {
        error.append("Character has no collider!");
    } else if (colliders.size() > 1) {
        error.append("Character has more than one collider!");
    }

    return error;
}

double Character::get_speed() const {
    return speed;
}

void Character::set_speed(const double& _speed) {
    speed = _speed;
}

double Character::get_movement() const {
    return max_movement;
}

void Character::set_movement(const double& _movement) {
    max_movement = _movement;
}

void Character::enable(bool _active) {
    if (active == _active) {
        return;
    }

    active = _active;

    if (active) {
        emit_signal("activated");
    } else {
        emit_signal("deactivated");
    }
}

bool Character::is_active() const {
    return active;
}

void Character::_bind_methods() {
    using namespace godot;
    ADD_SIGNAL(MethodInfo("activated"));
    ADD_SIGNAL(MethodInfo("deactivated"));

    ClassDB::bind_method(D_METHOD("get_speed"), &Character::get_speed);
    ClassDB::bind_method(D_METHOD("set_speed", "speed"), &Character::set_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "speed"), "set_speed", "get_speed");

    ClassDB::bind_method(D_METHOD("get_movement"), &Character::get_movement);
    ClassDB::bind_method(D_METHOD("set_movement", "movement"), &Character::set_movement);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "max_movement"), "set_movement", "get_movement");

    ClassDB::bind_method(D_METHOD("get_active"), &Character::is_active);
    ClassDB::bind_method(D_METHOD("set_active", "enable"), &Character::enable);
}
