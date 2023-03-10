# webrtc-native-build

Native build of Google's webrtc library. The library is also packaged with BoringSSL and libyuv.

* [WebRTC](https://webrtc.org/) is a standard for real-time audio/video/data communication and is mostly used in web browsers.
* [BoringSSL](https://github.com/google/boringssl) is a fork of OpenSSL that is designed to meet Google's needs.
* [libyuv](https://chromium.googlesource.com/libyuv/libyuv/) is an open source project that includes YUV scaling and conversion functionalities.

## License
By default, libwebrtc is built with non-free codecs. To build without them, change the following flags in [generate_ninja_files.bash](3rdParty/webrtc_native/generate_ninja_files.bash) and [generate_ninja_files.bat](3rdParty/webrtc_native/generate_ninja_files.bat).

```bash
rtc_use_h264=false
proprietary_codecs=false
ffmpeg_branding="Chromium"
```

## Dependencies (Linux)
```bash
sudo apt-get install ninja-build cmake build-essential libssl-dev libboost-all-dev
sudo apt-get install libglib2.0-dev libgtk-3-dev libpulse-dev libasound2-dev

# For cross compiling
sudo apt-get install g++-aarch64-linux-gnu gcc-aarch64-linux-gnu
sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
```

## Dependencies (Mac)
```bash
# XCode and homebrew must be installed first.
brew install ninja
```

## Building

```bash
# Create build directory
mkdir build
# Go to build directory
cd build
# Run CMake with arguments
cmake ../ [-DCMAKE_BUILD_TYPE=Release|Debug] [-DCMAKE_BUILD_ARCHITECTURE=arm32|arm64|amd64|win64|osx64]
# Parallel build
make -j
# will copy to dist directory
make install
```

## Building on Windows
Building on Windows is not supported yet for recent versions of WebRTC.
You can submit a PR to help with this if you wish.
If you want to build on Windows, you can use the tag `4389.e7d9f7.130`.
There is also a prebuilt version of the library available in the releases section on GitHub.

### Dependencies
* [Ninja](https://github.com/ninja-build/ninja/releases)
    * Copy `ninja.exe` in `3rdParty/webrtc_native/`
* [CMake](https://cmake.org/download)
* [Git](https://git-scm.com/download/win)
* [Python](https://www.python.org/downloads)
* [MSVC 2019 Build Tools](https://visualstudio.microsoft.com/vs/older-downloads/#visual-studio-2019-and-other-products)
* Windows SDK 10.1.19041 (make sure that it is checked while installing MSVC)
* Windows SDK Debugging Tools
    1. Navigate to `Control Panel` -> `Programs` -> `Programs and Features`
    2. Right-click on `Windows Software Development Kit`, and choose `Change`
    3. Select `Change` and click `Next`
    4. Check the box for `Debugging Tools for Windows` and click `Change`
Make sure to check `Add to PATH` for everything you install

### Setup
* Create a copy of your `<python_dir>/python.exe` executable as `<python_dir>/python3.exe`.
* Make sure that `python`, `python3`, `cmake` and `git` are in your path.
* Make sure the registry entry `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem::LongPathsEnabled` is set to `0x1`
* Launch a `CMD` prompt as Administrator, and execute `git config --system core.longpaths true`

### Building
Using a CMD prompt (not tested with `powershell` or `git-bash` or any other shell)
```powershell
# Create build directory
mkdir build
# Go to build directory
cd build
# Run CMake with arguments
cmake .. -G "Ninja" [-DCMAKE_BUILD_TYPE=Release|Debug]
# Parallel build
ninja
# Copy to dist directory
ninja install
# Generate a zip archive in build/
ninja package
```
### Important notes
* You might have trouble building if your system is not in English
* You might have trouble building if the full path to `python.exe` has at least one space in it

### Consuming the library
On Windows, you will have to link any target that consumes this library to these additional Windows libraries:
* `secur32`
* `winmm`
* `dmoguids`
* `wmcodecdspuuid`
* `msdmo`
* `strmiids`


If you don't link against these libraries, your linker might see missing symbols like these ones:
* `__imp_timeGetTime`
* `__imp_timeKillEvent`
* `__imp_timeSetEvent`
* `__imp_timeBeginPeriod`
* `__imp_timeEndPeriod`
* `CLSID_CWMAudioAEC`
* `IID_IMediaObject`
* `IID_IMediaBuffer`
* `MoInitMediaType`
* `MoFreeMediaType`
* `InitializeSecurityContextA`
* `AcquireCredentialsHandleA`
* `__imp_FreeCredentialsHandle`
* `CompleteAuthToken`
* `__imp_DeleteSecurityContext`

## Versioning Scheme

`branch-head-number`.`first-6-digits-of-webrtc-commit-hash`.`patch-number`

To find the `patch-number` for a given `branch-head-number`, use the following web page:
`https://chromium.googlesource.com/chromium/src/+/branch-heads/<branch-head-number>/chrome/VERSION`

## Dropped support

### MacOS 10.15 Catalina
GitHub Actions dropped support for MacOS 10.15 Catalina.
However, the latest tag might still work to build under MacOS 10.15.
There are also prebuilt versions of the library available in the releases section on GitHub, for tag version `5039.5df5b1.1` and earlier.

## Authors

* Marc-Antoine Maheux (@mamaheux)
* Dominic Létourneau (@doumdi)
* Philippe Warren (@philippewarren)

## License

* [Apache License, Version 2.0](LICENSE)

## Sponsor

![IntRoLab](https://introlab.3it.usherbrooke.ca/IntRoLab.png)

[IntRoLab - Intelligent / Interactive / Integrated / Interdisciplinary Robot Lab](https://introlab.3it.usherbrooke.ca)
