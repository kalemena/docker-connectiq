
# Check at https://developer.garmin.com/downloads/connect-iq/sdks/sdks.json
VERSION := 4.0.1-2021-04-16-d9c4c2c97

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
	COMMAND=/opt/eclipse/eclipse CIQ_WORKSPACE=/home/menny/dev/menny bash ./run.sh
