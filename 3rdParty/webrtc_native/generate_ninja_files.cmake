message(STATUS "Architecture: ${ARCHITECTURE}")
message(STATUS "Sysroot: ${SYSROOT}")

if(NOT DEFINED A)
    set(A "")
endif()
if(NOT DEFINED EXTRAS)
    set(EXTRAS "")
endif()
if(NOT DEFINED EXTRA_FLAGS)
    set(EXTRA_FLAGS "")
endif()
if(NOT DEFINED GN_CMD)
    set(GN_CMD "gn")
endif()

if(${ARCHITECTURE} MATCHES "x86_64|amd64")
    set(A "x64")
    set(EXTRAS "")
    set(EXTRA_FLAGS "is_clang=false target_os=\\\"linux\\\"")
elseif(${ARCHITECTURE} MATCHES "i.86")
    set(A "x86")
    set(EXTRAS "")
    set(EXTRA_FLAGS "is_clang=false target_os=\\\"linux\\\"")
elseif(${ARCHITECTURE} MATCHES "win64")
    set(A "x64")
    set(EXTRAS "")
    set(EXTRA_FLAGS "is_clang=false target_os=\\\"win\\\"")
elseif(${ARCHITECTURE} MATCHES "arm32|armhf|armv.*")
    set(A "arm")
    set(EXTRAS " arm_float_abi=\\\"hard\\\"")
    set(EXTRA_FLAGS "is_clang=false use_sysroot=true sysroot=\\\"${SYSROOT}\\\" target_os=\\\"linux\\\"")
elseif(${ARCHITECTURE} MATCHES "arm64|aarch64")
    set(A "arm64")
    set(EXTRAS "")
    set(EXTRA_FLAGS "is_clang=false use_sysroot=true sysroot=\\\"${SYSROOT}\\\" target_os=\\\"linux\\\"")
elseif(${ARCHITECTURE} MATCHES "osx64")
    set(A "x64")
    set(EXTRAS "")
    set(EXTRA_FLAGS "is_clang=true")
else()
    message(WARNING "Unknown target platform: ${A}, continuing anyway")
endif()

set(COMMON_FLAGS "is_component_build=false treat_warnings_as_errors=false fatal_linker_warnings=false use_gio=false use_rtti=true use_custom_libcxx=false use_custom_libcxx_for_host=false rtc_enable_protobuf=false rtc_include_tests=false rtc_use_h264=true proprietary_codecs=true target_cpu=\\\"${A}\\\"${EXTRAS} enable_iterator_debugging=false rtc_build_examples=false rtc_use_pipewire=false")

execute_process(
    COMMAND ${GN_CMD} gen out/Debug --args="is_debug=true ${COMMON_FLAGS} ${EXTRA_FLAGS}"
)
execute_process(
    COMMAND ${GN_CMD} gen out/Release --args="is_debug=false ${COMMON_FLAGS} ${EXTRA_FLAGS}"
)

execute_process(
    COMMAND ${GN_CMD} args --list out/Debug
)
