#include <godot_cpp/godot.hpp>
#include <godot_cpp/core/class_db.hpp>

#include "Character.h"
#include "Ability.h"

void register_gameplay_types(godot::ModuleInitializationLevel level) {
    if (level != godot::ModuleInitializationLevel::MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }

    // Register Classes
    godot::ClassDB::register_class<Character>();
    godot::ClassDB::register_class<Ability>();
}

void unregister_gameplay_types(godot::ModuleInitializationLevel level) {
    if (level != godot::MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
}

extern "C" {
    GDExtensionBool GDE_EXPORT universe_engine_init(GDExtensionInterfaceGetProcAddress interface, GDExtensionClassLibraryPtr library, GDExtensionInitialization* initialization) {
        godot::GDExtensionBinding::InitObject init_object(interface, library, initialization);
        init_object.register_initializer(register_gameplay_types);
        init_object.register_terminator(unregister_gameplay_types);
        init_object.set_minimum_library_initialization_level(godot::ModuleInitializationLevel::MODULE_INITIALIZATION_LEVEL_SCENE);

        return init_object.init();
    }
}
