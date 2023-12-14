#include <godot_cpp/godot.hpp>
#include <godot_cpp/core/class_db.hpp>

#include "Character.h"
#include "Ability.h"
#include "Pathfinding.h"
#include "GraphicalUtility.h"
#include "Scenario.h"
#include "Region.h"

void register_gameplay_types(godot::ModuleInitializationLevel level) {
    switch (level) {
        case godot::MODULE_INITIALIZATION_LEVEL_CORE:
            break;
        case godot::MODULE_INITIALIZATION_LEVEL_SERVERS:
            break;
        case godot::MODULE_INITIALIZATION_LEVEL_EDITOR:
            godot::ClassDB::register_class<Region>();
            godot::ClassDB::register_class<SubRegion>();
            break;
        case godot::MODULE_INITIALIZATION_LEVEL_SCENE:
            // Register Classes
            godot::ClassDB::register_class<Character>();
            godot::ClassDB::register_class<Ability>();
            godot::ClassDB::register_class<Pathfinding>();
            godot::ClassDB::register_class<GraphicalUtility>();
            godot::ClassDB::register_class<Scenario>();
            break;
    }

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
        init_object.set_minimum_library_initialization_level(godot::ModuleInitializationLevel::MODULE_INITIALIZATION_LEVEL_EDITOR);

        return init_object.init();
    }
}
