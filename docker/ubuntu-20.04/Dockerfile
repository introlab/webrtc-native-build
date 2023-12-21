FROM ubuntu:20.04
# Change default shell to bash
SHELL ["/bin/bash", "--login", "-c"]

# Install build dependencies
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
	build-essential git sudo vim libprotobuf-dev protobuf-compiler locales wget curl cmake \
    ninja-build  libssl-dev libboost-all-dev libglib2.0-dev libgtk-3-dev libpulse-dev libasound2-dev

# Install cross-compiler
RUN apt install -y g++-aarch64-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

# Set Working directory
WORKDIR /root

# Checkout code
RUN git clone -b update-webrtc  https://github.com/introlab/webrtc-native-build.git --recurse-submodules

WORKDIR /root/webrtc-native-build

RUN mkdir build

WORKDIR /root/webrtc-native-build/build

RUN cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_BUILD_ARCHITECTURE=amd64
RUN make -j4
RUN make install

RUN mkdir /data

WORKDIR /root/webrtc-native-build/dist
CMD ["/bin/bash", "-c", "tar cvzf /data/release.tar.gz ."]