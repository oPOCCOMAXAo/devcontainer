IMAGE := poccomaxa/devcontainer
TAG := $(shell git describe --tags --exact-match 2>/dev/null)

.PHONY: build-latest
build-latest:
	docker build -t $(IMAGE):latest .

.PHONY: push-latest
push-latest:
	docker push $(IMAGE):latest

.PHONY: add-tag
add-tag:
	@test -n "$(TAG)" || (echo "HEAD is not exactly on a git tag" >&2; exit 1)
	docker tag $(IMAGE):latest $(IMAGE):$(TAG)

.PHONY: push-tag
push-tag:
	@test -n "$(TAG)" || (echo "HEAD is not exactly on a git tag" >&2; exit 1)
	docker push $(IMAGE):$(TAG)

.PHONY: release
release:
	$(MAKE) build-latest
	$(MAKE) add-tag
	$(MAKE) push-latest
	$(MAKE) push-tag
