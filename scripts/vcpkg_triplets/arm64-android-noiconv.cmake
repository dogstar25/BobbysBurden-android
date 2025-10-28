# scripts/vcpkg_triplets/arm64-android-noiconv.cmake

# --- Core vcpkg triplet settings ---
set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CMAKE_SYSTEM_NAME Android)
set(VCPKG_CMAKE_SYSTEM_VERSION 24)
set(VCPKG_TARGET_IS_64_BIT ON)

set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

# --- Chainload the Android toolchain (only if not already provided) ---
# Prefer to let your Gradle -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE win.
if(NOT DEFINED VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
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
endif()

# --- CRUCIAL: force ABI/Platform into every port configure ---
# These options are appended to all vcpkg_cmake_configure() calls.
# (Also seed CMAKE_ANDROID_ARCH_ABI for good measure.)
list(APPEND VCPKG_CMAKE_CONFIGURE_OPTIONS
        "-DANDROID_ABI=arm64-v8a"
        "-DANDROID_PLATFORM=24"
        "-DCMAKE_ANDROID_ARCH_ABI=arm64-v8a"
)

# --- Your original SDL/iconv-related toggles (keep) ---
list(APPEND VCPKG_CMAKE_CONFIGURE_OPTIONS
        "-DCMAKE_DISABLE_FIND_PACKAGE_Iconv=ON"
        "-DSDL_ICONV=OFF"
        "-DSDL2MIXER_WAVPACK=OFF"
)

# --- Optional: keep the env for ports if you’ve set these at process level ---
# (Harmless; can help debugging)
set(VCPKG_KEEP_ENV_VARS "ANDROID_ABI;ANDROID_PLATFORM;ANDROID_NDK_HOME;ANDROID_NDK")

# --- Debug prints (VCPKG_TARGET_TRIPLET may be empty here) ---
message(STATUS "Todd VCPKG_TRIPLETS - [vcpkg] ${VCPKG_TARGET_TRIPLET}; CHAINLOAD=${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}")
message(STATUS "Todd VCPKG_TRIPLETS - ARCH=${VCPKG_TARGET_ARCHITECTURE}  (expect arm64)")
message(STATUS "Todd VCPKG_TRIPLETS - Forcing: ANDROID_ABI=arm64-v8a  ANDROID_PLATFORM=24 into port configures")
