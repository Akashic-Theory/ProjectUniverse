#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/window.hpp>
#include <godot_cpp/classes/area3d.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/input_event.hpp>
#include <godot_cpp/classes/navigation_agent3d.hpp>
#include <godot_cpp/classes/input.hpp>

#include "Scenario.h"

VARIANT_ENUM_CAST(Scenario::TeamType);

Scenario::Scenario() :
                    teams(),
                    turn(0),
                    selected(nullptr),
                    hover_material(nullptr) {
    teams = {{PLAYER},
             {ALLY},
             {ENEMY},
             {EVENT}};
}

void Scenario::process_mouse_event(Character* character, godot::MeshInstance3D* mesh, bool entered) {
    //godot::UtilityFunctions::print(character->is_active(), entered, selected == character);
    if (entered && character->is_active()) {
        mesh->set_surface_override_material(0, hover_material);
    } else if (!entered && character != selected) {
        mesh->set_surface_override_material(0, nullptr);
    }
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

    if (team == PLAYER) {
        godot::Area3D* collider = cast_to<godot::Area3D>(character->find_child("Area3D"));
        godot::MeshInstance3D* mesh = cast_to<godot::MeshInstance3D>(character->find_child("Mesh"));
        godot::NavigationAgent3D* agent = cast_to<godot::NavigationAgent3D>(character->find_child("NavigationAgent3D"));

        if (!collider) {
            ERR_FAIL_MSG(godot::vformat("Failed to find 'Area3D' in children of %s", character->get_name()));
        }
        if (!mesh) {
            ERR_FAIL_MSG(godot::vformat("Failed to find 'Mesh' in children of %s", character->get_name()));
        }
        if (!agent) {
            ERR_FAIL_MSG(godot::vformat("Failed to find 'NavigationAgent3D' in children of %s", character->get_name()));
        }

        // Collision Signals
        collider->connect("input_event", callable_mp(this, &Scenario::handle_input).bind(character));
        collider->connect("mouse_entered", callable_mp(this, &Scenario::process_mouse_event).bind(character, mesh, true));
        collider->connect("mouse_exited", callable_mp(this, &Scenario::process_mouse_event).bind(character, mesh, false));

        // NavAgent Signals
        agent->connect("navigation_finished", callable_mp(character, &Character::movement_ended));

        // Connect UI
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

godot::Ref<godot::Material> Scenario::get_hover_material() const {
    return hover_material;
}

void Scenario::set_hover_material(godot::Ref<godot::Material> _hover_material) {
    hover_material = _hover_material;
}

void Scenario::handle_input(godot::Node* camera, godot::InputEvent* event, godot::Vector3 position, godot::Vector3 normal,
                            int shape_idx, godot::Object* source) {
    // For clicking on characters
    Character* character = cast_to<Character>(source);

    if (character && character->is_active() && event->is_action_pressed("click")) {
        select_character(character);
        return;
    }

    // Terrain interaction
    godot::Area3D* terrain = cast_to<godot::Area3D>(source);

    // TODO: Replace terrain with custom type
    if (terrain && terrain->get_name() == godot::StringName("TerrainCollider")) {
        if (teams[turn].teamType == PLAYER && selected && !selected->is_moving()) {
            if (godot::Input::get_singleton()->is_action_pressed("move_hover")){
                if (event->is_action_pressed("start_move")) {
                    selected->moving = true;

                    return;
                }
                selected->set_target(position);
            } else {
                selected->set_target(selected->get_global_position());
            }
        }
    }

}

void Scenario::select_character(Character* character) {
    if (selected == character) {
        // TODO: Figure out why the below code mystery crashes the game
//        emit_signal("character_deselected", selected);
//        godot::MeshInstance3D* mesh = cast_to<godot::MeshInstance3D>(selected->find_child("Mesh"));
//        if (mesh) {
//            mesh->set_surface_override_material(0, nullptr);
//        }
//
//        selected = nullptr;
        return;
    }

    if (selected) {
        emit_signal("character_deselected", selected);
        godot::MeshInstance3D* mesh = cast_to<godot::MeshInstance3D>(selected->find_child("Mesh"));
        if (mesh) {
            mesh->set_surface_override_material(0, nullptr);
        }
    }

    selected = character;
    if (selected) {
        emit_signal("character_selected", selected);
    }
}

Scenario::TeamType Scenario::start_next_turn() {
    godot::UtilityFunctions::print("Ending turn ", turn);
    deactivate(turn);
    emit_signal("turn_ended", turn);
    turn = (turn + 1) % teams.size();
    godot::UtilityFunctions::print("Starting turn ", turn);
    activate(turn);
    emit_signal("turn_started", turn);
    return teams[turn].teamType;
}

void Scenario::set_turn(Scenario::TeamType team) {
    godot::UtilityFunctions::print("Ending turn ", turn);
    select_character(nullptr);
    deactivate(turn);
    emit_signal("turn_ended", turn);

    for (int i = 0; i < teams.size(); i++) {
        if (teams[i].teamType == team) {
            turn = i;
            break;
        }
    }

    godot::UtilityFunctions::print("Starting turn ", turn);
    activate(turn);
    emit_signal("turn_started", turn);
}

void Scenario::_bind_methods() {
    using namespace godot;
    PropertyInfo characterProp = PropertyInfo(godot::Variant::OBJECT, "character");
    characterProp.class_name = "Character";
    ADD_SIGNAL(MethodInfo("character_selected", characterProp));
    ADD_SIGNAL(MethodInfo("character_deselected", characterProp));

    PropertyInfo teamProp = PropertyInfo(godot::Variant::INT, "team");
    ADD_SIGNAL(MethodInfo("turn_started", teamProp));
    ADD_SIGNAL(MethodInfo("turn_ended", teamProp));

    BIND_ENUM_CONSTANT(PLAYER);
    BIND_ENUM_CONSTANT(ALLY);
    BIND_ENUM_CONSTANT(ENEMY);
    BIND_ENUM_CONSTANT(EVENT);

    ClassDB::bind_method(D_METHOD("get_hover_material"), &Scenario::get_hover_material);
    ClassDB::bind_method(D_METHOD("set_hover_material", "hover_material"), &Scenario::set_hover_material);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "hover_material", PROPERTY_HINT_RESOURCE_TYPE, "Material"), "set_hover_material", "get_hover_material");

    ClassDB::bind_method(D_METHOD("handle_input", "camera", "event", "position", "normal", "shape_idx", "source"),
                         &Scenario::handle_input);
    ClassDB::bind_method(D_METHOD("register_character", "team", "character"),
                         &Scenario::register_character);
    ClassDB::bind_method(D_METHOD("print_characters"),
                         &Scenario::print_characters);
    ClassDB::bind_method(D_METHOD("start_next_turn"),
                         &Scenario::start_next_turn);
    ClassDB::bind_method(D_METHOD("set_turn", "team"),
                         &Scenario::set_turn);
    ClassDB::bind_method(D_METHOD("select_character", "character"),
                         &Scenario::select_character);
}
