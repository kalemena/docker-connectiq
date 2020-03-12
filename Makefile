
VERSION := 3.1.8-2020-03-04-e5981d10b

all: build 

pull:
	docker pull kalemena/connectiq:$(VERSION)

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) -t kalemena/connectiq:$(VERSION) .
	docker tag kalemena/connectiq:$(VERSION) kalemena/connectiq:latest

console:
	bash ./run.sh

eclipse:
	COMMAND=/opt/eclipse/eclipse bash ./run.sh
