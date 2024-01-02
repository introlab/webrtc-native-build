cmake_minimum_required(VERSION 3.10.0)

project(webrtc-native-build NONE)


# Verify build architecture
if (CMAKE_BUILD_ARCHITECTURE MATCHES arm64)
    set(CMAKE_SYSTEM_NAME Linux)
    set(CMAKE_SYSTEM_PROCESSOR arm64)
    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
    set(CMAKE_SYSROOT ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/webrtc_native/webrtc/src/build/linux/debian_bullseye_arm64-sysroot)
    set(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc-10)
    set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++-10)
elseif (CMAKE_BUILD_ARCHITECTURE MATCHES arm32)
    set(CMAKE_SYSTEM_NAME Linux)
    set(CMAKE_SYSTEM_PROCESSOR armhf)
    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
    set(CMAKE_SYSROOT ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/webrtc_native/webrtc/src/build/linux/debian_bullseye_arm-sysroot)
    set(CMAKE_C_COMPILER /usr/bin/arm-linux-gnueabihf-gcc-10)
    set(CMAKE_CXX_COMPILER /usr/bin/arm-linux-gnueabihf-g++-10)

elseif (CMAKE_BUILD_ARCHITECTURE MATCHES win64)
    # Nothing to do
else()
    # Will use native compiler
    if (APPLE)
        set(CMAKE_BUILD_ARCHITECTURE osx64)
    elseif(WIN32)
        set(CMAKE_BUILD_ARCHITECTURE win64)
    else()
        set(CMAKE_BUILD_ARCHITECTURE amd64)
    endif()

    # set(CMAKE_SYSROOT ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/webrtc_native/webrtc/src/build/linux/debian_bullseye_amd64-sysroot)
endif()

# Verify build type
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif ()


message(STATUS "Building ${CMAKE_PROJECT_NAME} with Architecture: ${CMAKE_BUILD_ARCHITECTURE} Build type: ${CMAKE_BUILD_TYPE}")


file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/VERSION VERSION_FROM_FILE)
string(REPLACE "." ";" VERSION_LIST ${VERSION_FROM_FILE})
list(GET VERSION_LIST 0 WEBRTC_NATIVE_BUILD_VERSION_MAJOR)
list(GET VERSION_LIST 1 WEBRTC_NATIVE_BUILD_VERSION_MINOR)
list(GET VERSION_LIST 2 WEBRTC_NATIVE_BUILD_VERSION_PATCH)

SET(WEBRTC_NATIVE_BUILD_VERSION ${WEBRTC_NATIVE_BUILD_VERSION_MAJOR}.${WEBRTC_NATIVE_BUILD_VERSION_MINOR}.${WEBRTC_NATIVE_BUILD_VERSION_PATCH})

message(STATUS "WEBRTC_NATIVE_BUILD_VERSION : ${WEBRTC_NATIVE_BUILD_VERSION}")



if (POLICY CMP0014)
    cmake_policy(SET CMP0014 NEW)
endif (POLICY CMP0014)

if (POLICY CMP0048)
    cmake_policy(SET CMP0048 NEW)
endif (POLICY CMP0048)




set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/dist/${CMAKE_BUILD_TYPE}/${CMAKE_PROJECT_NAME}-${WEBRTC_NATIVE_BUILD_VERSION})
message(STATUS "CMAKE_INSTALL_PREFIX : ${CMAKE_INSTALL_PREFIX}")

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if (CMAKE_BUILD_TYPE MATCHES Debug)
    add_definitions(-DDEBUG=1)
endif ()

if (CMAKE_BUILD_TYPE MATCHES Release)
    add_definitions(-DRELEASE=1)
endif ()

if (MSVC)
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
endif (MSVC)

function(assign_source_group)
    foreach (_source IN ITEMS ${ARGN})
        if (IS_ABSOLUTE "${_source}")
            file(RELATIVE_PATH _source_rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_source}")
        else ()
            set(_source_rel "${_source}")
        endif ()
        get_filename_component(_source_path "${_source_rel}" PATH)
        string(REPLACE "/" "\\" _source_path_msvc "${_source_path}")
        source_group("${_source_path_msvc}" FILES "${_source}")
    endforeach ()
endfunction(assign_source_group)

if (WIN32)
    # set(CMAKE_CXX_FLAGS "-fPIC")
    # add_definitions(-DWEBRTC_POSIX)
    list(APPEND boringssl_INCLUDE "${CMAKE_CURRENT_LIST_DIR}/3rdParty/webrtc_native/webrtc/src/third_party/boringssl/src/include")
    list(APPEND webrtc_native_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/3rdParty/webrtc_native/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/webrtc.lib")
    list(APPEND boringssl_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/3rdParty/webrtc_native/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/third_party/boringssl/boringssl.lib")
    list(APPEND libyuv_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/3rdParty/webrtc_native/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/third_party/libyuv/libyuv_internal.lib")

    set(CPACK_PACKAGE_FILE_NAME ${CMAKE_PROJECT_NAME}-msvc-2022-win64-${CMAKE_BUILD_TYPE}-${WEBRTC_NATIVE_BUILD_VERSION})
    set(CPACK_GENERATOR "ZIP")
    include(CPack)
elseif (UNIX)
    set(CMAKE_CXX_FLAGS "-fPIC")
    add_definitions(-DWEBRTC_POSIX)
    list(APPEND boringssl_INCLUDE "${CMAKE_CURRENT_LIST_DIR}/3rdParty/webrtc_native/webrtc/src/third_party/boringssl/src/include")
    list(APPEND webrtc_native_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/3rdParty/webrtc_native/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/libwebrtc.a" dl X11 expat)
    list(APPEND boringssl_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/3rdParty/webrtc_native/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/third_party/boringssl/libboringssl.a")
    list(APPEND libyuv_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/3rdParty/webrtc_native/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/third_party/libyuv/libyuv_internal.a")
endif (WIN32)


add_subdirectory(3rdParty)
