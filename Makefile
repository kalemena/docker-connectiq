
VERSION := 3.0.12-2019-06-12-77ed6f47e

all: build 

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) -t kalemena/connectiq:$(VERSION) .

build-with-eclipse:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) --build-arg ADDITIONAL_PACKAGES=eclipse -t kalemena/connectiq:$(VERSION)-eclipse .

run:
	docker run --rm -it kalemena/connectiq bash
