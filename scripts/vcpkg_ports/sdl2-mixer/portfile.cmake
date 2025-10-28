vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libsdl-org/SDL_mixer
    REF "release-${VERSION}"
    SHA512 653ec1f0af0b749b9ed0acd3bfcaa40e1e1ecf34af3127eb74019502ef42a551de226daef4cc89e6a51715f013e0ba0b1e48ae17d6aeee931271f2d10e82058a
    PATCHES
        fix-pkg-prefix.patch
)

message(STATUS "Todd - SDL2MIXER PORT: TARGET_TRIPLET=${TARGET_TRIPLET}")
message(STATUS "Todd - SDL2MIXER PORT: CURRENT_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}")
message(STATUS "Todd - SDL2MIXER PORT: VCPKG_ROOT_DIR=${VCPKG_ROOT_DIR}")
message(STATUS "Todd - SDL2MIXER PORT: CMAKE_ANDROID_ARCH_ABI=${CMAKE_ANDROID_ARCH_ABI}")
message(STATUS "Todd - SDL2MIXER PORT: CMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Todd - SDL2MIXER PORT: SIZEOF_VOID_P=${CMAKE_SIZEOF_VOID_P}")

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        fluidsynth SDL2MIXER_MIDI_FLUIDSYNTH
        libflac SDL2MIXER_FLAC
        libflac SDL2MIXER_FLAC_LIBFLAC
        libmodplug SDL2MIXER_MOD
        libmodplug SDL2MIXER_MOD_MODPLUG
        mpg123 SDL2MIXER_MP3
        mpg123 SDL2MIXER_MP3_MPG123
        timidity SDL2MIXER_MIDI_TIMIDITY
        wavpack SDL2MIXER_WAVPACK
        wavpack SDL2MIXER_WAVPACK_DSD
        opusfile SDL2MIXER_OPUS
)

if("fluidsynth" IN_LIST FEATURES OR "timidity" IN_LIST FEATURES)
    list(APPEND FEATURE_OPTIONS "-DSDL2MIXER_MIDI=ON")
else()
    list(APPEND FEATURE_OPTIONS "-DSDL2MIXER_MIDI=OFF")
endif()

if("fluidsynth" IN_LIST FEATURES)
    vcpkg_find_acquire_program(PKGCONFIG)
    list(APPEND EXTRA_OPTIONS "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}")
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

# Tell the private SDL2 finder where SDL2 actually is
message(STATUS "Todd - CURRENT_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}")
set(_SDL2_INC     "${CURRENT_INSTALLED_DIR}/include")
set(_SDL2_LIB_DBG "${CURRENT_INSTALLED_DIR}/debug/lib/libSDL2.a")
set(_SDL2_LIB_REL "${CURRENT_INSTALLED_DIR}/lib/libSDL2.a")

set(_SDL2_CANDIDATES
        "${CURRENT_INSTALLED_DIR}/include/SDL2/SDL.h"
        "${CURRENT_INSTALLED_DIR}/include/SDL.h"
)

set(_SDL2_HEADER_FOUND FALSE)
foreach(_h IN LISTS _SDL2_CANDIDATES)
    if(EXISTS "${_h}")
        get_filename_component(SDL2_INCLUDE_DIR "${_h}" DIRECTORY)
        message(STATUS "Todd - [sdl2-mixer overlay] Found SDL2 headers at: ${SDL2_INCLUDE_DIR}")
        set(_SDL2_HEADER_FOUND TRUE)
        break()
    endif()
endforeach()

if(NOT _SDL2_HEADER_FOUND)
    message(FATAL_ERROR
            "Todd - [sdl2-mixer overlay] SDL2 headers not found. Checked:\n${_SDL2_CANDIDATES}\n\n"
            "Ensure 'sdl2' is installed for ${TARGET_TRIPLET} (and listed as a dependency).")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        ${EXTRA_OPTIONS}
        -DSDL2MIXER_VENDORED=OFF
        -DSDL2MIXER_SAMPLES=OFF
        -DSDL2MIXER_DEPS_SHARED=OFF
        -DSDL2MIXER_OPUS_SHARED=OFF
        -DSDL2MIXER_VORBIS_VORBISFILE_SHARED=OFF
        -DSDL2MIXER_VORBIS="VORBISFILE"
        -DSDL2MIXER_FLAC_DRFLAC=OFF
        -DSDL2MIXER_MIDI_NATIVE=OFF
        -DSDL2MIXER_MP3_DRMP3=OFF
        -DSDL2MIXER_WAVPACK=OFF
        -DMUSIC_WAVPACK=OFF
        -DSDL2MIXER_MOD_XMP_SHARED=${BUILD_SHARED}
        -DSDL2_INCLUDE_DIR=${_SDL2_INC}
    OPTIONS_DEBUG
        -DSDL2_LIBRARY=${_SDL2_LIB_DBG}
    OPTIONS_RELEASE
        -DSDL2_LIBRARY=${_SDL2_LIB_REL}
    MAYBE_UNUSED_VARIABLES
        SDL2MIXER_MP3_DRMP3
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(
    PACKAGE_NAME "SDL2_mixer"
    CONFIG_PATH "lib/cmake/SDL2_mixer"
)
vcpkg_fixup_pkgconfig()

set(debug_libname "SDL2_mixerd")
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" AND VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/SDL2_mixer.pc" "-lSDL2_mixer" "-lSDL2_mixer-static")
    set(debug_libname "SDL2_mixer-staticd")
endif()

if(NOT VCPKG_BUILD_TYPE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/SDL2_mixer.pc" "-lSDL2_mixer" "-l${debug_libname}")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
