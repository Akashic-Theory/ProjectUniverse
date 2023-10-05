#pragma once

#include <godot_cpp/classes/node.hpp>

class Ability : public godot::Node {
    GDCLASS(Ability, godot::Node);
public:
    enum Targeting {
        AUTO,
        UNIT,
        SMITE,
        LINE,
        VECTOR
    };
private:
    Targeting mode;
protected:
    static void _bind_methods();
public:
    Ability() = default;
    ~Ability() = default;

    [[nodiscard]] Targeting get_mode() const;
    void set_mode(const Targeting mode);
};

VARIANT_ENUM_CAST(Ability::Targeting);
