# Check at https://developer.garmin.com/downloads/connect-iq/sdks/sdks.json
# VERSION := 3.1.9-2020-06-24-1cc9d3a70
# VERSION := 3.2.1-2020-08-20-56ff593b7
# VERSION := 4.0.1-2021-04-16-d9c4c2c97
VERSION := 4.0.3-2021-06-01-b7cc78017

all: build 

pull:
	docker pull kalemena/connectiq:$(VERSION)

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:20.04
	docker build --build-arg VERSION=$(VERSION) -t kalemena/connectiq:$(VERSION) .
	docker tag kalemena/connectiq:$(VERSION) kalemena/connectiq:latest

console:
	bash ./run.sh

eclipse:
	COMMAND=/opt/eclipse/eclipse bash ./run.sh
