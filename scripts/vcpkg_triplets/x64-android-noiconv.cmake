# x64-android-noiconv.cmake — emulator build, mirrors your arm64 triplet
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CMAKE_SYSTEM_NAME Android)
set(VCPKG_CMAKE_SYSTEM_VERSION 24)
set(VCPKG_TARGET_IS_64_BIT ON)

set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

# Chain-load NDK toolchain (Gradle usually passes this; fall back to env)
if(NOT DEFINED VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
    if(DEFINED ENV{ANDROID_NDK_HOME})
        set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "$ENV{ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake")
    endif()
endif()

# NDK 27 + some ports use IN_LIST with old cmake_minimum_required
list(APPEND VCPKG_CMAKE_CONFIGURE_OPTIONS "-DCMAKE_POLICY_DEFAULT_CMP0057=NEW")

# Paranoid but harmless: force ABI/platform and disable iconv bits we don’t want
list(APPEND VCPKG_CMAKE_CONFIGURE_OPTIONS
        "-DANDROID_ABI=x86_64"
        "-DANDROID_PLATFORM=24"
        "-DCMAKE_DISABLE_FIND_PACKAGE_Iconv=ON"
        "-DSDL_ICONV=OFF"
        "-DSDL2MIXER_WAVPACK=OFF"
)

set(VCPKG_KEEP_ENV_VARS "ANDROID_ABI;ANDROID_PLATFORM;ANDROID_NDK_HOME;ANDROID_NDK")

message(STATUS "x64-android-noiconv: ABI=x86_64, API=24, chainload=${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}")
