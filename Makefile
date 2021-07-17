# Check at https://developer.garmin.com/downloads/connect-iq/sdks/sdks.json
# VERSION := 3.1.9-2020-06-24-1cc9d3a70
VERSION := 4.0.5-2021-08-10-29788b0dc

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
