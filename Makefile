.PHONY: image test

DOCKER_RUN ?= docker run --rm
MONGODB_URI ?= mongodb://mongodb/minidoc_test

image:
	docker build -t codeclimate/minidoc .

test: image
	$(DOCKER_RUN) \
	  --env MONGODB_URI="$(MONGODB_URI)" \
	  --volume "$(PWD)":/app \
	  codeclimate/minidoc bundle exec rspec $(RSPEC_ARGS)
