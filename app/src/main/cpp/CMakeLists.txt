cmake_minimum_required(VERSION 3.22)
project(BobbysBurdenAndroid LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Resolve the project root relative to THIS file (app/src/main/cpp)
# cpp dir -> main -> src -> app -> (repo root)
get_filename_component(PROJECT_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../../../" REALPATH)

message(STATUS "PROJECT_ROOT = ${PROJECT_ROOT}")

# Bring in submodules (engine + game lib) BEFORE defining the app .so
add_subdirectory("${PROJECT_ROOT}/MobyDick"     "${CMAKE_BINARY_DIR}/MobyDick_build")
add_subdirectory("${PROJECT_ROOT}/BobbysBurden" "${CMAKE_BINARY_DIR}/BobbysBurden_build")

# Shared library that Android loads (produces libbobbysburden.so)
add_library(bobbysburden SHARED
        main.cpp
)

# If MobyDick exposes its public headers (it does), you technically don't
# need these includes. Keeping them explicit is fine and unblocks includes.
target_include_directories(bobbysburden PRIVATE
        "${PROJECT_ROOT}/MobyDick/include"
        "${PROJECT_ROOT}/BobbysBurden/src"
)

# Link the engine + game libs and Android system libs
target_link_libraries(bobbysburden PRIVATE
        MobyDick
        BobbysBurden
        android
        log
        EGL
        GLESv3
)
