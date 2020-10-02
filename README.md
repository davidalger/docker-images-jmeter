# jMeter Docker Images

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Build Instructions

```
docker build . -t davidalger/jmeter:5.1.1 --build-arg JMETER_VERSION=5.1.1
docker push davidalger/jmeter:5.1.1

docker build . -t davidalger/jmeter:5.2.1 --build-arg JMETER_VERSION=5.2.1
docker push davidalger/jmeter:5.2.1

docker build . -t davidalger/jmeter:5.3 --build-arg JMETER_VERSION=5.3
docker push davidalger/jmeter:5.3
```

## Author Information

This project was started in 2019 by [David Alger](https://davidalger.com/).
