.PHONY: image test citest irb bundle

DOCKER_RUN ?= docker run --rm
MONGODB_URI ?= mongodb://mongodb/minidoc_test

image:
	docker build -t codeclimate/minidoc .

test: image
	$(DOCKER_RUN) \
	  --env MONGODB_URI="$(MONGODB_URI)" \
	  --volume "$(PWD)":/app \
	  codeclimate/minidoc bundle exec rspec $(RSPEC_ARGS)

# Route named service hosts to the docker bridge
citest: DOCKER_BRIDGE_IP=$(shell ip addr show dev docker0 | sed '/^.*inet \(.*\)\/.*$$/!d; s//\1/')
citest:
	docker run \
	  --add-host mongodb:$(DOCKER_BRIDGE_IP) \
	  --env MONGODB_URI="$(MONGODB_URI)" \
	  --volume $(PWD):/app \
	  codeclimate/minidoc bundle exec rspec && ./cc-test-reporter after-build --prefix "/app"

irb: image
	$(DOCKER_RUN) -it \
	  --env MONGODB_URI="$(MONGODB_URI)" \
	  --volume "$(PWD)":/app \
	  codeclimate/minidoc irb -I lib -r minidoc

bundle:
	$(DOCKER_RUN) \
	  --volume "$(PWD)":/app \
	  codeclimate/minidoc bundle $(BUNDLE_ARGS)