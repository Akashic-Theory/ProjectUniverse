#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/window.hpp>

#include "Scenario.h"

VARIANT_ENUM_CAST(Scenario::TeamType);

Scenario::Scenario() {
    teams = {{PLAYER},
             {ALLY},
             {ENEMY},
             {EVENT}};
    turn = 0;
    selected = nullptr;
}

void Scenario::deactivate(size_t team) const {
    for (const auto& character: teams[team].members) {
        character->enable(false);
    }
}

void Scenario::activate(size_t team) const {
    for (const auto& character: teams[team].members) {
        character->enable(true);
    }
}

void Scenario::register_character(const TeamType team, Character* character) {
    if (!character) {
        ERR_PRINT("Attempted to register an invalid character");
        return;
    }
    teams[team].members.push_back(character);
}

void Scenario::print_characters() const {
    const char* teamnames[] = {"Player",
                         "Ally",
                         "Enemy",
                         "Event"};
    for (auto& team: teams) {
        std::cout << teamnames[team.teamType] << '\n';
        for (auto& character: team.members) {
            std::cout << '\t' << character->get_name().to_utf8_buffer().ptr() << '\n';
        }
    }
}

void Scenario::select_character(Character* character) {
    if (selected) {
        emit_signal("character_deselected", selected);
    }
    selected = character;
    if (selected) {
        emit_signal("character_selected", selected);
    }
}

Scenario::TeamType Scenario::start_next_turn() {
    godot::UtilityFunctions::print("Ending turn", turn);
    deactivate(turn);
    turn = (turn + 1) % teams.size();
    godot::UtilityFunctions::print("Starting turn", turn);
    activate(turn);
    return teams[turn].teamType;
}

void Scenario::_bind_methods() {
    using namespace godot;
    PropertyInfo characterProp = PropertyInfo(godot::Variant::OBJECT, "character");
    characterProp.class_name = "Character";
    ADD_SIGNAL(MethodInfo("character_selected", characterProp));
    ADD_SIGNAL(MethodInfo("character_deselected", characterProp));

    BIND_ENUM_CONSTANT(PLAYER);
    BIND_ENUM_CONSTANT(ALLY);
    BIND_ENUM_CONSTANT(ENEMY);
    BIND_ENUM_CONSTANT(EVENT);

    ClassDB::bind_method(D_METHOD("register_character", "team", "character"),
                         &Scenario::register_character);
    ClassDB::bind_method(D_METHOD("print_characters"),
                         &Scenario::print_characters);
    ClassDB::bind_method(D_METHOD("start_next_turn"),
                         &Scenario::start_next_turn);
    ClassDB::bind_method(D_METHOD("select_character", "character"),
                         &Scenario::select_character);
}
