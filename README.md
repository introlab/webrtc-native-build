# webrtc-native-build

Native build of Google's webrtc library. The library is also packaged with BoringSSL.

* [WebRTC](https://webrtc.org/) is a standard for real-time audio/video/data communication and is mostly used in web browsers.
* [BoringSSL](https://github.com/google/boringssl) is a fork of OpenSSL that is designed to meet Google's needs.


## Dependencies
```bash
sudo apt-get install ninja-build cmake build-essential libssl-dev libboost-all-dev 
sudo apt-get install libglib2.0-dev libgtk-3-dev libpulse-dev libasound2-dev 
sudo apt-get install g++-aarch64-linux-gnu gcc-aarch64-linux-gnu
```

## Building

```bash
# Create build directory
mkdir build
# Go to build directory
cd build
# Run CMake with arguments
cmake ../ [-DCMAKE_BUILD_TYPE=Release|Debug] [-DCMAKE_BUILD_ARCHITECTURE=arm64|amd64]
# Parallel build
make -j
# will copy to dist directory
make install
```

## Versioning Scheme
`branch-head-number`.`commit-hash`.`patch-number`

## Authors

* Marc-Antoine Maheux (@mamaheux)
* Dominic Létourneau (@doumdi)

## License

* [Apache License, Version 2.0](LICENSE)

## Sponsor

![IntRoLab](https://introlab.3it.usherbrooke.ca/IntRoLab.png)

[IntRoLab - Intelligent / Interactive / Integrated / Interdisciplinary Robot Lab](https://introlab.3it.usherbrooke.ca)
