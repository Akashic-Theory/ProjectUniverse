project(projectuniverse)

set(SRC src/gdextension_registration.cpp
        src/Ability.cpp
        src/Character.cpp
        src/Pathfinding.cpp
        src/Region.cpp
        src/Scenario.cpp
        src/plugin/RegionPlugin.cpp
        src/util/GraphicalUtility.cpp
)

set(HEAD include/Ability.h
        include/Character.h
        include/Pathfinding.h
        include/Region.h
        include/Scenario.h
        include/plugin/RegionPlugin.h
        include/util/GraphicalUtility.h
)

add_compile_options("$<$<CONFIG:Debug>:-DDEBUG>")
add_library(${PROJECT_NAME} SHARED ${SRC} ${HEAD})

target_include_directories(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PROJECT_NAME} PUBLIC godot::cpp)

set_target_properties(${PROJECT_NAME} PROPERTIES
        OUTPUT_NAME "$<TARGET_NAME:${PROJECT_NAME}>$<$<CONFIG:Debug>:_d>")
