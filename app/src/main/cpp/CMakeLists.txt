cmake_minimum_required(VERSION 3.22)
project(BobbysBurdenAndroid LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Define the base working path for the engine and all games that use it and we have to use cache so
# that the MobyDick CMAKELists.txt can see this variable
set(GAME_WORKING_DIR "BobbysBurden" CACHE STRING "Relative path to game assets" FORCE)

# Submodules: engine + shared game code
add_subdirectory(${CMAKE_SOURCE_DIR}/../../../../MobyDick MobyDick_build)
add_subdirectory(${CMAKE_SOURCE_DIR}/../../../../BobbysBurden BobbysBurden_build)

# Build the Android shared lib from your ONE entry file
add_library(bobbysburden SHARED
        main.cpp
)

target_link_libraries(bobbysburden PRIVATE
        MobyDickEngine
        BobbysBurdenGame
        android
        log
        EGL
        GLESv3
)
