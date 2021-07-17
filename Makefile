# Check at https://developer.garmin.com/downloads/connect-iq/sdks/sdks.json
# VERSION := 3.1.9-2020-06-24-1cc9d3a70
VERSION := 4.0.4-2021-07-01-9df386fcd

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
