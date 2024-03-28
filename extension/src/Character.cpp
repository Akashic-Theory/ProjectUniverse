#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/collision_object3d.hpp>
#include <godot_cpp/classes/navigation_agent3d.hpp>

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

double Character::get_remaining_movement() const {
    return remaining_movement;
}

void Character::set_remaining_movement(const double& _movement) {
    remaining_movement = _movement;
}

void Character::set_target(const godot::Vector3 &position) {
    //TODO: Cache agent reference
    godot::NavigationAgent3D* agent = cast_to<godot::NavigationAgent3D>(find_child("NavigationAgent3D"));
    agent->set_target_position(position);
}

void Character::enable(bool _active) {
    if (active == _active) {
        return;
    }

    active = _active;

    if (active) {
        remaining_movement = max_movement;
        emit_signal("moved", remaining_movement);
        emit_signal("activated");
    } else {
        emit_signal("deactivated");
    }
}

bool Character::is_active() const {
    return active;
}

bool Character::is_moving() const {
    return moving;
}

void Character::start_moving() {
    //godot::UtilityFunctions::print("movement started");
    moving = true;
}

void Character::movement_ended() {
    //godot::UtilityFunctions::print("movement stopped");
    moving = false;
//    if (remaining_movement < 1){
//        remaining_movement = 0;
//    }
    emit_signal("moved", remaining_movement);
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

    PropertyInfo moveProp = PropertyInfo(godot::Variant::FLOAT, "remaining");
    ADD_SIGNAL(MethodInfo("moved", moveProp));

    ClassDB::bind_method(D_METHOD("get_remaining_movement"), &Character::get_remaining_movement);
    ClassDB::bind_method(D_METHOD("set_remaining_movement", "movement"), &Character::set_remaining_movement);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "remaining_movement"), "set_remaining_movement", "get_remaining_movement");

    ClassDB::bind_method(D_METHOD("set_target", "position"), &Character::set_target);

    ClassDB::bind_method(D_METHOD("get_active"), &Character::is_active);
    ClassDB::bind_method(D_METHOD("set_active", "enable"), &Character::enable);
    ClassDB::bind_method(D_METHOD("is_moving"), &Character::is_moving);
    ClassDB::bind_method(D_METHOD("start_moving"), &Character::start_moving);
}
