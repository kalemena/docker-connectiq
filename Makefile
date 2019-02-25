
VERSION := 3.0.8-2019-1-23-8f00e4f

all: build 

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) -t kalemena/connectiq:$(VERSION) .
