#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/material.hpp>

#include "Character.h"

class Scenario: public godot::Node3D {
    GDCLASS(Scenario, godot::Node3D);
public:
    enum TeamType {
        PLAYER,
        ALLY,
        ENEMY,
        EVENT
    };
    struct Team {
        TeamType                teamType;
        std::vector<Character*> members;
    };
private:
    std::vector<Team> teams;
    size_t turn;
    Character* selected;
    godot::Ref<godot::Material> hover_material;

    void activate(size_t team) const;
    void deactivate(size_t team) const;
    void process_mouse_event(Character* character, godot::MeshInstance3D* mesh, bool entered);
protected:
    static void _bind_methods();
public:
    Scenario();

    [[nodiscard]] godot::Ref<godot::Material> get_hover_material() const;
    void set_hover_material(godot::Ref<godot::Material> hover_material);
    virtual void handle_input(godot::Node* camera, godot::InputEvent* event, godot::Vector3 position, godot::Vector3 normal, int shape_idx, godot::Object* source);
    void register_character(TeamType team, Character* character);
    void print_characters() const;
    void select_character(Character* character);
    [[nodiscard]] Character* get_selected() const;
    TeamType start_next_turn();
    void set_turn(TeamType team);
};
