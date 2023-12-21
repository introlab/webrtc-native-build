docker buildx build -t webrtc --build-arg BUILD_TYPE=Debug --build-arg BUILD_ARCHITECTURE=arm64 --build-arg BUILD_BRANCH=update-webrtc .
docker run --rm \
    --volume $PWD:/data \
    webrtc tar cvzf /data/release.tar.gz ./