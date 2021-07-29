#!/bin/bash

architecture=$1
sysroot=$2

echo "Architecture: $architecture"
echo "Sysroot: $sysroot"

extras=""
extra_flags=""

case "$architecture" in
	i?86)
		a=x86
		extras=""
		extra_flags="target_os=\"linux\""
	;;
	x86_64|amd64)
		a=x64
		extras=""
		extra_flags="target_os=\"linux\""
	;;
	win64)
		a=x64
		extras=""
		extra_flags="target_os=\"windows\""
	;;
	arm32|armhf|armv*)
		a=arm
		extras=" arm_float_abi=\"hard\""
		extra_flags="use_sysroot=true sysroot=\"$sysroot\" target_os=\"linux\""
	;;
	arm64|aarch64)
		a=arm64
		extras=""
		extra_flags="use_sysroot=true sysroot=\"$sysroot\" target_os=\"linux\""
	;;
	*)
		echo>&2 "WARNING: Unknown target platform: $a, continuing anyway"
	;;
esac


common_flags="is_clang=true is_component_build=false treat_warnings_as_errors=false fatal_linker_warnings=false use_gio=false use_rtti=true use_custom_libcxx=false use_custom_libcxx_for_host=false rtc_enable_protobuf=false rtc_include_tests=false rtc_use_h264=true proprietary_codecs=true target_cpu=\"$a\"$extras enable_iterator_debugging=false rtc_build_examples=false rtc_use_pipewire=false"


gn gen out/Debug --args="is_debug=true $common_flags $extra_flags"
gn gen out/Release --args="is_debug=false $common_flags $extra_flags"

