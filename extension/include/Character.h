#pragma once

#include <godot_cpp/classes/node3d.hpp>

class Character : public godot::Node3D {
GDCLASS(Character, godot::Node3D);
private:
    bool active;

    // Godot properties
    double speed;
    double max_movement;

protected:
    static void _bind_methods();

public:
    Character();
    ~Character();

    // Accessors
    double get_speed() const;
    void set_speed(const double& speed);
    double get_movement() const;
    void set_movement(const double& movement);
    void enable(bool active = true);
    bool is_active() const;

    [[nodiscard]] godot::PackedStringArray _get_configuration_warnings() const;
};
