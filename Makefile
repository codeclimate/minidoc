.PHONY: image mongodb-test-server test citest irb

DOCKER_RUN ?= docker run --rm
MONGODB_URI ?= mongodb://mongodb/minidoc_test

image:
	docker build -t codeclimate/minidoc .

mongodb-test-server:
	docker network inspect minidoc >/dev/null || docker network create minidoc
	docker run \
		--detach \
		--rm \
		--network minidoc \
		--name mongodb \
		circleci/mongo:3.2

test:
	$(DOCKER_RUN) -it \
		--network minidoc \
	  --env MONGODB_URI="$(MONGODB_URI)" \
	  --volume "$(PWD)":/app \
	  codeclimate/minidoc bundle exec rspec $(RSPEC_ARGS)

citest:
	docker run \
		--network minidoc \
		--env MONGODB_URI="mongodb://mongodb/minidoc_test" \
		--name "minidoc-${CIRCLE_WORKFLOW_ID}" \
	  codeclimate/minidoc bundle exec rspec
	docker cp "minidoc-${CIRCLE_WORKFLOW_ID}":/app/coverage ./coverage

irb: image
	$(DOCKER_RUN) -it \
	  --env MONGODB_URI="$(MONGODB_URI)" \
	  --volume "$(PWD)":/app \
	  codeclimate/minidoc irb -I lib -r minidoc

bundle:
	$(DOCKER_RUN) \
	  --volume "$(PWD)":/app \
	  codeclimate/minidoc bundle $(BUNDLE_ARGS)
