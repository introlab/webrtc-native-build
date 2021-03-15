# webrtc-native-build
Native build of Google's webrtc library.

[WebRTC](https://webrtc.org/) is a standard for real-time audio/video/data communication and is mostly used in web browsers.


## Dependencies
```bash
apt-get install list all modules...
```

## Building

```bash
mkdir build
cd build
cmake ../
make -j
# will copy to dist directory
make install
```

## Authors

* Marc-Antoine Maheux (@mamaheux)
* Dominic Létourneau (@doumdi)

## License

* [Apache License, Version 2.0](LICENSE)

## Sponsor

![IntRoLab](https://introlab.3it.usherbrooke.ca/IntRoLab.png)

[IntRoLab - Intelligent / Interactive / Integrated / Interdisciplinary Robot Lab](https://introlab.3it.usherbrooke.ca)
