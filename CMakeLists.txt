cmake_minimum_required(VERSION 3.19)
project(gdextension-projectuniverse)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
endif()

add_subdirectory(deps)
add_subdirectory(extension)

add_custom_target(create_link ALL
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${CMAKE_SOURCE_DIR}/gdproj/extension/bin"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:projectuniverse>" "${CMAKE_SOURCE_DIR}/gdproj/extension/bin/$<LOWER_CASE:${CMAKE_SYSTEM_NAME}>/$<TARGET_NAME:projectuniverse>$<$<CONFIG:Debug>:_d>${CMAKE_SHARED_LIBRARY_SUFFIX}"
        COMMENT "Copying output"
        DEPENDS projectuniverse
)

install(TARGETS "projectuniverse"
        RUNTIME DESTINATION "bin/$<LOWER_CASE:${CMAKE_SYSTEM_NAME}>"
        LIBRARY DESTINATION "bin/$<LOWER_CASE:${CMAKE_SYSTEM_NAME}>")
