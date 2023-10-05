project(projectuniverse)

set(SRC src/gdextension_registration.cpp
        src/Character.cpp
        src/Ability.cpp)

add_library(${PROJECT_NAME} SHARED ${SRC} ${HEAD})

target_include_directories(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PROJECT_NAME} PUBLIC godot::cpp)
