#! /usr/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`

patch -u $SCRIPT_PATH/../3rdParty/webrtc_native/webrtc/src/third_party/libvpx/BUILD.gn $SCRIPT_PATH/libvpx_BUILD.gn.patch
patch -u $SCRIPT_PATH/../3rdParty/webrtc_native/webrtc/src/third_party/libvpx/source/config/linux/arm64-highbd/vp9_rtcd.h $SCRIPT_PATH/libvpx_linux_arm64-highbd_vp9_rtcd.h.patch
patch -u $SCRIPT_PATH/../3rdParty/webrtc_native/webrtc/src/third_party/libvpx/source/config/linux/arm64-highbd/vpx_dsp_rtcd.h $SCRIPT_PATH/libvpx_linux_arm64_vpx_dsp_rtcd.h.patch
patch -u $SCRIPT_PATH/../3rdParty/webrtc_native/webrtc/src/third_party/libvpx/source/config/linux/arm64/vp9_rtcd.h $SCRIPT_PATH/libvpx_linux_arm64_vp9_rtcd.h.patch
patch -u $SCRIPT_PATH/../3rdParty/webrtc_native/webrtc/src/third_party/libvpx/source/config/linux/arm64/vpx_dsp_rtcd.h $SCRIPT_PATH/libvpx_linux_arm64_vpx_dsp_rtcd.h.patch
