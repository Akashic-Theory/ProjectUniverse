#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

#include "Character.h"
#include "Ability.h"

Character::Character() {
    godot::UtilityFunctions::print("Test");
}

Character::~Character() {

}

godot::PackedStringArray Character::_get_configuration_warnings() const {
    godot::PackedStringArray error;
    auto                     abilities = find_children("", "Ability");
    if (abilities.size() == 0) {
        error.append("Character has no abilities!");
    }
    return error;
}

double Character::get_speed() const {
    return speed;
}

void Character::set_speed(const double& _speed) {
    speed = _speed;
}

void Character::_bind_methods() {
    using namespace godot;
    ClassDB::bind_method(D_METHOD("get_speed"), &Character::get_speed);
    ClassDB::bind_method(D_METHOD("set_speed", "speed"), &Character::set_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "speed"), "set_speed", "get_speed");
}
