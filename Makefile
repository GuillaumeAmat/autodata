SHELL := /bin/bash
DOCKER_IMAGE := ekino/docker-buildbox:node6.10-2017.03.30

# Install project and dependencies
install:
	npm install

# Lint and test
lint_test:
	npm run lint
	npm test

# Run project
dev:
	npm start

build:
	npm run clean
	npm run build:doc
	npm run build:dev
	npm run build:prod

# Prepare for release
prepare:
	make lint_test
	make build

kill:
	docker rm -f autodata

docker-install:
	(make kill | exit 0)
	docker run --rm --name autodata -v `pwd`:/code -w /code ${DOCKER_IMAGE} yarn

# Starts docker image and launch dev server
docker-dev:
	(make kill | exit 0)
	docker run -p 8080:8080 -h autodata --rm --name autodata -v `pwd`:/code -w /code ${DOCKER_IMAGE} yarn start

# Starts docker image and launch doc server
docker-doc:
	(make kill | exit 0)
	docker run -p 4000:4000 -h autodata --rm --name autodata -v `pwd`:/code -w /code ${DOCKER_IMAGE} yarn doc

# Open shell on running docker container
shell:
	docker exec -ti autodata /bin/bash
