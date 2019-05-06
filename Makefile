IMAGE_NAME:=labyrelm
IMAGE_TAG:=${IMAGE_NAME}:latest
REMOTE_TAG:=hal:5000/${IMAGE_NAME}

.PHONY: build
build:
	docker build  -t $(IMAGE_TAG) .

.PHONY: tag
tag:
	docker tag $(IMAGE_TAG) $(REMOTE_TAG)

.PHONY: push
push: compile build tag
	docker push $(REMOTE_TAG)

.PHONY: compile
compile:
	npm run prod
