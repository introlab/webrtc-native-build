docker buildx build -t webrtc .
docker run --rm \
    --volume $PWD:/data \
    webrtc tar cvzf /data/release.tar.gz ./