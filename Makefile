IMG_NAME ?= opsani/servo-k8s-prom-hey
IMG_TAG ?= latest

container:
	docker build . -t $(IMG_NAME):$(IMG_TAG)

push:
	docker push $(IMG_NAME):$(IMG_TAG)
