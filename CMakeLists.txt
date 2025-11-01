cmake_minimum_required(VERSION 3.22)

project(BobbysBurdenAndroid LANGUAGES CXX)

message(STATUS "Todd - ANDROID_ABI=${ANDROID_ABI} CMAKE_ANDROID_ARCH_ABI=${CMAKE_ANDROID_ARCH_ABI}")
message(STATUS "Todd - sizeof(void*)=${CMAKE_SIZEOF_VOID_P}")
message(STATUS "Todd - VCPKG_TARGET_TRIPLET=${VCPKG_TARGET_TRIPLET}")
message(STATUS "Todd - VCPKG_TARGET_ARCHITECTURE=${VCPKG_TARGET_ARCHITECTURE}")

add_subdirectory(app/src/main/cpp)

