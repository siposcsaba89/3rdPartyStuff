cmake_minimum_required(VERSION 3.13)
project(3rdparty)

cmake_policy(SET CMP0077 NEW)

macro(ignore_package NAME)
    file(WRITE ${CMAKE_BINARY_DIR}/ignored_packages/${NAME}/${NAME}Config.cmake "")
    set(${NAME}_DIR ${CMAKE_BINARY_DIR}/ignored_packages/${NAME})
    message(STATUS "ignoring ${NAME} find_package!")
endmacro()

include(cmake/vcpkg_apply_patches.cmake)

set(CMAKE_DEBUG_POSTFIX _d)
set(CMAKE_RELWITHDEBINFO_POSTFIX _rd)

add_subdirectory(source/eigen)
add_subdirectory(source/googletest)
add_subdirectory(source/glfw)
ignore_package(glfw3) # hack for not finding glfw, the target already exists
option(BUILD_IMGUI_OPENGL "Build imgui without opengl support" 0)
add_subdirectory(source/imgui)
set(CMAKE_SOURCE_DIR_TMP ${CMAKE_SOURCE_DIR})
set(CMAKE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/source/yaml-cpp)
add_subdirectory(source/yaml-cpp)
vcpkg_apply_patches(SOURCE_PATH source/yaml-cpp QUIET PATCHES source/patch/yaml-cpp/yaml-cpp_p1.patch)
set(CMAKE_SOURCE_DIR ${CMAKE_SOURCE_DIR_TMP})
add_subdirectory(source/jsoncpp)
