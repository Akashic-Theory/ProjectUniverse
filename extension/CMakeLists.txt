project(projectuniverse)

set(SRC src/gdextension_registration.cpp
        src/Character.cpp
        src/Ability.cpp
        src/Pathfinding.cpp
        src/GraphicalUtility.cpp
        src/Scenario.cpp
        src/Region.cpp
        src/plugin/RegionPlugin.cpp
)

set(HEAD include/Character.h
        include/Ability.h
        include/Pathfinding.h
        include/GraphicalUtility.h
        include/Scenario.h
        include/Region.h
        include/plugin/RegionPlugin.h
)

add_library(${PROJECT_NAME} SHARED ${SRC} ${HEAD})

target_include_directories(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PROJECT_NAME} PUBLIC godot::cpp)

set_target_properties(${PROJECT_NAME} PROPERTIES
        OUTPUT_NAME "$<TARGET_NAME:${PROJECT_NAME}>$<$<CONFIG:Debug>:_d>")
