IMAGE := poccomaxa/devcontainer
TAG := $(shell git describe --tags --exact-match 2>/dev/null)

.PHONY: build-latest push-latest push-tag release

build-latest:
	docker build -t $(IMAGE):latest .

push-latest:
	docker push $(IMAGE):latest

push-tag:
	@test -n "$(TAG)" || (echo "HEAD is not exactly on a git tag" >&2; exit 1)
	docker tag $(IMAGE):latest $(IMAGE):$(TAG)
	docker push $(IMAGE):$(TAG)

release:
	$(MAKE) build-latest
	$(MAKE) push-latest
	$(MAKE) push-tag
