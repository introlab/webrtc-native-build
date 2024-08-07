FROM ubuntu:24.04
# Change default shell to bash
SHELL ["/bin/bash", "--login", "-c"]

# Install build dependencies
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
	build-essential git sudo vim libprotobuf-dev protobuf-compiler locales wget curl cmake pkg-config ca-certificates \
    ninja-build  libssl-dev libboost-all-dev libglib2.0-dev libgtk-3-dev libpulse-dev libasound2-dev patch

# Install cross-compiler
RUN apt install -y g++-aarch64-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf clang

# Define a build-time argument
ARG BUILD_TYPE=Release
ARG BUILD_ARCHITECTURE=amd64
ARG BUILD_BRANCH=main

# Set Working directory
WORKDIR /root

# Checkout code
RUN git clone -b ${BUILD_BRANCH}  https://github.com/introlab/webrtc-native-build.git --recurse-submodules

WORKDIR /root/webrtc-native-build
RUN mkdir build

WORKDIR /root/webrtc-native-build/build
RUN cmake ../ -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_BUILD_ARCHITECTURE=${BUILD_ARCHITECTURE}

WORKDIR /root/webrtc-native-build/3rdParty/webrtc_native/webrtc/src/third_party/boringssl/src
RUN git checkout 7c2b62e93487b772990fddc1905f22d4cfaee4a4

WORKDIR /root/webrtc-native-build/build
RUN ../patches/apply_patch.sh
RUN cmake ../ -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_BUILD_ARCHITECTURE=${BUILD_ARCHITECTURE}
RUN export PATH=/root/webrtc-native-build/3rdParty/depot_tools:$PATH && make -j2
RUN make install

VOLUME [ "/data" ]

WORKDIR /root/webrtc-native-build/dist/${BUILD_TYPE}
CMD ["/bin/bash", "-c", "tar cvzf /data/release.tar.gz ."]
