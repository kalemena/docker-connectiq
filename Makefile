
VERSION := 3.1.7-2020-01-23-a3869d977

all: build 

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:16.04
	docker build --build-arg VERSION=$(VERSION) -t kalemena/connectiq:$(VERSION) .
	docker tag kalemena/connectiq:$(VERSION) kalemena/connectiq:latest

build-with-eclipse:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:16.04
	docker build --build-arg VERSION=$(VERSION) --build-arg ADDITIONAL_PACKAGES=eclipse -t kalemena/connectiq:$(VERSION)-eclipse .

run:
	docker run --rm -it kalemena/connectiq bash
