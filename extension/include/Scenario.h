#pragma once

#include <godot_cpp/classes/node3d.hpp>

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

    void activate(size_t team) const;
    void deactivate(size_t team) const;
protected:
    static void _bind_methods();
public:
    Scenario();

    void register_character(TeamType team, Character* character);
    void print_characters() const;
    void select_character(Character* character);
    TeamType start_next_turn();
};
