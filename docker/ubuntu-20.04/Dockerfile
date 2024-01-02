FROM ubuntu:20.04
# Change default shell to bash
SHELL ["/bin/bash", "--login", "-c"]

# Install build dependencies
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
	build-essential git sudo vim libprotobuf-dev protobuf-compiler locales wget curl cmake pkg-config ca-certificates \
    ninja-build  libssl-dev libboost-all-dev libglib2.0-dev libgtk-3-dev libpulse-dev libasound2-dev patch

# Install cross-compiler
RUN apt install -y gcc-10-aarch64-linux-gnu libc6-dev-arm64-cross g++-10-aarch64-linux-gnu gcc-10-arm-linux-gnueabihf g++-10-arm-linux-gnueabihf clang

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
RUN make -j2
RUN make install

VOLUME [ "/data" ]

WORKDIR /root/webrtc-native-build/dist/${BUILD_TYPE}
CMD ["/bin/bash", "-c", "tar cvzf /data/release.tar.gz ."]