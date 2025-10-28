cmake_minimum_required(VERSION 3.22)
project(BobbysBurdenAndroid LANGUAGES CXX)

message(STATUS "Todd_APP_CMAKE - ANDROID_ABI=${ANDROID_ABI}  CMAKE_ANDROID_ARCH_ABI=${CMAKE_ANDROID_ARCH_ABI}")
message(STATUS "Todd_APP_CMAKE - CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}  CMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}")
message(STATUS "Todd_APP_CMAKE - CMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "Todd_APP_CMAKE - VCPKG_CHAINLOAD_TOOLCHAIN_FILE=${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}")
message(STATUS "Todd_APP_CMAKE - CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")
message(STATUS "Todd_APP_CMAKE - CMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}")
message(STATUS "Todd_APP_CMAKE - sizeof(void*)=${CMAKE_SIZEOF_VOID_P}")
message(STATUS "Todd_APP_CMAKE - CMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
message(STATUS "Todd_APP_CMAKE - CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
message(STATUS "Todd_APP_CMAKE - VCPKG_TARGET_TRIPLET=${VCPKG_TARGET_TRIPLET}")
message(STATUS "Todd_APP_CMAKE - VCPKG_TARGET_ARCHITECTURE=${VCPKG_TARGET_ARCHITECTURE}")

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Define the base working path for the engine and all games that use it and we have to use cache so
# that the MobyDick CMAKELists.txt can see this variable
set(GAME_WORKING_DIR "BobbysBurden" CACHE STRING "Relative path to game assets" FORCE)
# Resolve the project root relative to THIS file (app/src/main/cpp)
# cpp dir -> main -> src -> app -> (repo root)
get_filename_component(PROJECT_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../../../" REALPATH)

message(STATUS "Todd_APP_CMAKE - PROJECT_ROOT = ${PROJECT_ROOT}")

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
