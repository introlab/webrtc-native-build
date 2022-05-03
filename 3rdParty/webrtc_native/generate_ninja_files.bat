@echo off

set args=is_component_build=false^
         treat_warnings_as_errors=false^
         fatal_linker_warnings=false^
         use_gio=false^
         use_rtti=true^
         use_custom_libcxx=false^
         use_custom_libcxx_for_host=false^
         rtc_enable_protobuf=false^
         rtc_include_tests=false^
         rtc_use_h264=true^
         proprietary_codecs=true^
         ffmpeg_branding=\"Chrome\"^
         target_cpu=\"x64\"^
         enable_iterator_debugging=false^
         rtc_build_examples=false^
         rtc_use_pipewire=false^
         is_clang=true^
         use_lld=false^
         use_custom_libcxx=false^
         target_os=\"win\"

call "..\..\..\depot_tools\gn.bat" gen out\Release --args="is_debug=false %args%"
call "..\..\..\depot_tools\gn.bat" gen out\Debug --args="is_debug=true %args%"
