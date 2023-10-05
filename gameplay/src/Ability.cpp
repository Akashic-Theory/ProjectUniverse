#include "Ability.h"

#include <godot_cpp/core/class_db.hpp>

void Ability::_bind_methods() {
    using namespace godot;

    BIND_ENUM_CONSTANT(AUTO);
    BIND_ENUM_CONSTANT(UNIT);
    BIND_ENUM_CONSTANT(SMITE);
    BIND_ENUM_CONSTANT(LINE);
    BIND_ENUM_CONSTANT(VECTOR);

    ClassDB::bind_method(D_METHOD("get_mode"), &Ability::get_mode);
    ClassDB::bind_method(D_METHOD("set_mode", "mode"), &Ability::set_mode);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "Targeting Mode", PROPERTY_HINT_ENUM, "Auto,Unit,Smite,Line,Vector"),
                 "set_mode",
                 "get_mode");
}

Ability::Targeting Ability::get_mode() const {
    return mode;
}

void Ability::set_mode(const Ability::Targeting _mode) {
    mode = _mode;
}
