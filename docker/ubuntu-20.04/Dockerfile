FROM ubuntu:20.04
# Change default shell to bash
SHELL ["/bin/bash", "--login", "-c"]

# Install build dependencies
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
	build-essential git sudo vim libprotobuf-dev protobuf-compiler locales wget curl cmake pkg-config ca-certificates \
    ninja-build  libssl-dev libboost-all-dev libglib2.0-dev libgtk-3-dev libpulse-dev libasound2-dev patch

# Install cross-compiler
RUN apt install -y g++-10-aarch64-linux-gnu gcc-10-aarch64-linux-gnu gcc-10-arm-linux-gnueabihf g++-10-arm-linux-gnueabihf clang
RUN update-alternatives --install /usr/bin/aarch64-linux-gnu-gcc aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc-10 100
RUN update-alternatives --install /usr/bin/aarch64-linux-gnu-g++ aarch64-linux-gnu-g++ /usr/bin/aarch64-linux-gnu-g++-10 100
RUN update-alternatives --set aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc-10
RUN update-alternatives --set aarch64-linux-gnu-g++ /usr/bin/aarch64-linux-gnu-g++-10
RUN update-alternatives --install /usr/bin/arm-linux-gnueabihf-gcc arm-linux-gnueabihf-gcc /usr/bin/arm-linux-gnueabihf-gcc-10 100
RUN update-alternatives --install /usr/bin/arm-linux-gnueabihf-g++ arm-linux-gnueabihf-g++ /usr/bin/arm-linux-gnueabihf-g++-10 100
RUN update-alternatives --set arm-linux-gnueabihf-gcc /usr/bin/arm-linux-gnueabihf-gcc-10
RUN update-alternatives --set arm-linux-gnueabihf-g++ /usr/bin/arm-linux-gnueabihf-g++-10

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
RUN export PATH=/root/webrtc-native-build/3rdParty/depot_tools:$PATH && make -j2
RUN make install

VOLUME [ "/data" ]

WORKDIR /root/webrtc-native-build/dist/${BUILD_TYPE}
CMD ["/bin/bash", "-c", "tar cvzf /data/release.tar.gz ."]
