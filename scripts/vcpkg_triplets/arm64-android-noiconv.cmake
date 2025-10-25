set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME Android)

# Pull NDK from env, normalize slashes
set(_ndk "$ENV{ANDROID_NDK_HOME}")
if(NOT _ndk)
    set(_ndk "$ENV{ANDROID_NDK_ROOT}")
endif()
if(NOT _ndk)
    set(_ndk "$ENV{ANDROID_NDK}")
endif()
if(NOT _ndk)
    message(FATAL_ERROR "Set ANDROID_NDK_HOME (or ANDROID_NDK_ROOT / ANDROID_NDK) to your NDK path.")
endif()

file(TO_CMAKE_PATH "${_ndk}" _ndk_cmake)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${_ndk_cmake}/build/cmake/android.toolchain.cmake")

# Disable iconv paths
set(VCPKG_CMAKE_CONFIGURE_OPTIONS
        "-DCMAKE_DISABLE_FIND_PACKAGE_Iconv=ON"
        "-DSDL_ICONV=OFF"
        "-DSDL2MIXER_WAVPACK=OFF"
)

message(STATUS "[vcpkg] arm64-android-noiconv; NDK at: ${_ndk_cmake}")
