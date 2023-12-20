# VERSION MAJOR = 120, MINOR=0, BUILD=6099, PATCH=180
set(WEBRTC_CHECKOUT b0cc68e61205fd11a7256a6e85307ec17ad95790)

if(WIN32)

        list(APPEND CMAKE_PROGRAM_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../depot_tools/")

        message(STATUS "Current PATH: $ENV{PATH}")

        file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/webrtc)

        if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/webrtc/src")
            execute_process(
                COMMAND ${CMAKE_COMMAND} -E env DEPOT_TOOLS_WIN_TOOLCHAIN=0 ${CMAKE_CURRENT_SOURCE_DIR}/../depot_tools/fetch.bat webrtc
                WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/webrtc"
                RESULT_VARIABLE fetch_webrtc_result
            )
            if(NOT ${fetch_webrtc_result} EQUAL 0)
                message(FATAL_ERROR "\"fetch webrtc\" failed (${fetch_webrtc_result})")
            endif()

            execute_process(
                COMMAND ${CMAKE_COMMAND} -E env DEPOT_TOOLS_WIN_TOOLCHAIN=0 ${CMAKE_CURRENT_SOURCE_DIR}/../depot_tools/gclient.bat sync --with_branch_heads --with_tags
                WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/webrtc"
                RESULT_VARIABLE gclient_sync_webrtc_result
            )
            if(NOT ${gclient_sync_webrtc_result} EQUAL 0)
                message(FATAL_ERROR "\"gclient sync --with_branch_heads --with_tags\" failed (${gclient_sync_webrtc_result})")
            endif()

            execute_process(
                COMMAND git checkout ${WEBRTC_CHECKOUT}
                WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/webrtc/src"
                RESULT_VARIABLE git_checkout_webrtc_result
            )
            if(NOT ${git_checkout_webrtc_result} EQUAL 0)
                message(FATAL_ERROR "\"git checkout\" failed (${git_checkout_webrtc_result})")
            endif()

            execute_process(
                COMMAND ${CMAKE_COMMAND} -E env DEPOT_TOOLS_WIN_TOOLCHAIN=0 ${CMAKE_CURRENT_SOURCE_DIR}/../depot_tools/gclient.bat sync --with_branch_heads --with_tags
                WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/webrtc"
                RESULT_VARIABLE gclient_sync_webrtc_result
            )
            if(NOT ${gclient_sync_webrtc_result} EQUAL 0)
                message(FATAL_ERROR "\"gclient sync --with_branch_heads --with_tags\" failed (${gclient_sync_webrtc_result})")
            endif()
        endif()

        execute_process(
            COMMAND ${CMAKE_COMMAND} -E env DEPOT_TOOLS_WIN_TOOLCHAIN=0 "${CMAKE_CURRENT_SOURCE_DIR}/generate_ninja_files.bat"
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/webrtc/src"
            RESULT_VARIABLE generate_ninja_files_result
        )
        if(NOT ${generate_ninja_files_result} EQUAL 0)
            message(FATAL_ERROR "\"generate_ninja_files.cmake\" failed (${generate_ninja_files_result})")
        endif()

        add_custom_target(
            webrtc_native ALL
            COMMAND ${CMAKE_COMMAND} -E env DEPOT_TOOLS_WIN_TOOLCHAIN=0 ninja -C ${CMAKE_CURRENT_SOURCE_DIR}/webrtc/src/out/${CMAKE_BUILD_TYPE}
        )

else(WIN32)
    set(ENV{PATH} $ENV{PATH}:${CMAKE_CURRENT_LIST_DIR}/../depot_tools/)

    if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/webrtc")
        execute_process(
            COMMAND mkdir webrtc
            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
            RESULT_VARIABLE mkdir_webrtc_result
        )
        if(NOT ${mkdir_webrtc_result} EQUAL 0)
            message(FATAL_ERROR "\"mkdir webrtc\" failed (${mkdir_webrtc_result})")
        endif()
    endif()

    if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/webrtc/src")
        execute_process(
            COMMAND fetch webrtc
            WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/webrtc"
            RESULT_VARIABLE fetch_webrtc_result
        )
        if(NOT ${fetch_webrtc_result} EQUAL 0)
            message(FATAL_ERROR "\"fetch webrtc\" failed (${fetch_webrtc_result})")
        endif()

        execute_process(
            COMMAND gclient sync --with_branch_heads --with_tags
            WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/webrtc"
            RESULT_VARIABLE gclient_sync_webrtc_result
        )
        if(NOT ${gclient_sync_webrtc_result} EQUAL 0)
            message(FATAL_ERROR "\"gclient sync --with_branch_heads --with_tags\" failed (${gclient_sync_webrtc_result})")
        endif()

        execute_process(
            COMMAND git checkout ${WEBRTC_CHECKOUT}
            WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/webrtc/src"
            RESULT_VARIABLE git_checkout_webrtc_result
        )
        if(NOT ${git_checkout_webrtc_result} EQUAL 0)
            message(FATAL_ERROR "\"git checkout\" failed (${git_checkout_webrtc_result})")
        endif()

        execute_process(
            COMMAND gclient sync --with_branch_heads --with_tags
            WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/webrtc"
            RESULT_VARIABLE gclient_sync_webrtc_result
        )
        if(NOT ${gclient_sync_webrtc_result} EQUAL 0)
            message(FATAL_ERROR "\"gclient sync --with_branch_heads --with_tags\" failed (${gclient_sync_webrtc_result})")
        endif()
    endif()


    if (CMAKE_BUILD_ARCHITECTURE MATCHES arm64)
        execute_process(
            COMMAND python install-sysroot.py --arch=${CMAKE_BUILD_ARCHITECTURE}
            WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/webrtc/src/build/linux/sysroot_scripts"
            RESULT_VARIABLE build_sysroot_architecture
        )

        if(NOT ${build_sysroot_architecture} EQUAL 0)
            message(FATAL_ERROR "\"python install-sysroot.py --arch=arm64\" failed (${build_sysroot_architecture})")
        endif()
    endif()


    if (CMAKE_BUILD_ARCHITECTURE MATCHES arm32)
        execute_process(
                COMMAND python install-sysroot.py --arch=arm
                WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/webrtc/src/build/linux/sysroot_scripts"
                RESULT_VARIABLE build_sysroot_architecture
        )

        if(NOT ${build_sysroot_architecture} EQUAL 0)
            message(FATAL_ERROR "\"python install-sysroot.py --arch=arm\" failed (${build_sysroot_architecture})")
        endif()
    endif()


    execute_process(
        COMMAND "${CMAKE_CURRENT_LIST_DIR}/generate_ninja_files.bash" "${CMAKE_BUILD_ARCHITECTURE}" "${CMAKE_SYSROOT}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/webrtc/src"
        RESULT_VARIABLE generate_ninja_files_result
    )
    if(NOT ${generate_ninja_files_result} EQUAL 0)
        message(FATAL_ERROR "\"generate_ninja_files.cmake\" failed (${generate_ninja_files_result})")
    endif()

    add_custom_target(
            webrtc_native ALL
            COMMAND ninja -C ${CMAKE_CURRENT_LIST_DIR}/webrtc/src/out/${CMAKE_BUILD_TYPE}
    )
endif(WIN32)

# Manual installation of all dependencies.
list(GET webrtc_native_LIBRARY 0 webrtc_native_LIBRARY_only)
install(FILES ${webrtc_native_LIBRARY_only} DESTINATION lib)
install(FILES ${boringssl_LIBRARY} DESTINATION lib)
install(FILES ${libyuv_LIBRARY} DESTINATION lib)

install(DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/third_party/boringssl/boringssl DESTINATION lib)
install(DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/third_party/boringssl/boringssl_asm DESTINATION lib)
install(DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/webrtc/src/out/${CMAKE_BUILD_TYPE}/obj/third_party/libyuv/libyuv_internal DESTINATION lib)

# Install all includes except from third_party
install(DIRECTORY webrtc/src/ DESTINATION include
    FILES_MATCHING PATTERN "*.h"
    PATTERN webrtc/src/third_party EXCLUDE)

install(DIRECTORY webrtc/src/third_party/abseil-cpp/absl DESTINATION include
    FILES_MATCHING PATTERN "*.h")

install(DIRECTORY webrtc/src/third_party/boringssl/src/include/openssl DESTINATION include
    FILES_MATCHING PATTERN "*.h")

install(FILES webrtc/src/third_party/libyuv/include/libyuv.h DESTINATION include)
install(DIRECTORY webrtc/src/third_party/libyuv/include/libyuv DESTINATION include
    FILES_MATCHING PATTERN "*.h")
