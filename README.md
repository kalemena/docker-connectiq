# docker-connectiq

Installation of Garmin Tools in docker.

## Installation steps

* https://developer.garmin.com/connect-iq/programmers-guide/getting-started


### Manualy

```bash
$ wget https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-2.4.4.zip
$ export PATH=$PATH:path/to/connectiq-sdk/bin
$ apt install -y libwebkitgtk
```

- install eclipse latest (Oxygen)

### Docker image

Dockerfile recipe with monkeyc is available through docker hub.

To rebuild the image, run:

```bash
$ make build
```

# Links

* https://github.com/topics/connectiq
* https://github.com/stynoo/docker-garmin-backup
* https://github.com/blaskovicz/garmin-nest-camera-control
* https://github.com/4ch1m/HueCIQ
* https://github.com/britiger/PauseTimer-connectiq
* https://github.com/bugjam/garmin-eta/tree/master/ETA
* https://github.com/JoshuaTheMiller/Multivision-Watch
