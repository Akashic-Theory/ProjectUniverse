#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/vector3.hpp>

class Character : public godot::Node3D {
GDCLASS(Character, godot::Node3D);
friend class Scenario;
private:
    bool active;
    bool moving;

    // Godot properties
    double speed;
    double max_movement;
    double remaining_movement;

protected:
    static void _bind_methods();

public:
    Character();
    ~Character();

    // Accessors
    [[nodiscard]] double get_speed() const;
    void set_speed(const double& speed);
    [[nodiscard]] double get_movement() const;
    void set_movement(const double& movement);
    [[nodiscard]] double get_remaining_movement() const;
    void set_remaining_movement(const double& _movement);
    void set_target(const godot::Vector3& position);
    void enable(bool active = true);
    [[nodiscard]] bool is_active() const;
    [[nodiscard]] bool is_moving() const;
    void movement_ended();

    [[nodiscard]] godot::PackedStringArray _get_configuration_warnings() const;
};
