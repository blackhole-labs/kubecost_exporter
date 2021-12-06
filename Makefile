BINARY_NAME=kubecost_exporter
DOCKER_IMAGE_NAME=${BINARY_NAME}
REPO_OWNER=artemlive

GO           ?= go
GOFMT        ?= $(GO)fmt
GO_VERSION        ?= $(shell $(GO) version)
GO_VERSION_NUMBER ?= $(word 3, $(GO_VERSION))

VERSION=0.0.1
BUILD=$(date +%FT%T%z`)

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS =-ldflags "-w -s -X github.com/${REPO_OWNER}/kubecost-exporter/version.Version=${VERSION} -X github.com/${REPO_OWNER}/kubecost-exporter/version.BUILD=${BUILD}"

test:
	@echo "${TEST}"

build:
	go mod download
	go build ${LDFLAGS} -o bin/${BINARY_NAME}

run:
	go run ${LDFLAGS} -o bin/${BINARY_NAME}

build-docker-image: build
	@docker build . -t ${DOCKER_IMAGE_NAME}:${VERSION} -f docker/Dockerfile

compile:
	echo "Compiling for every OS and Platform"
	GOARCH=amd64 GOOS=darwin go build -o ${BINARY_NAME}-darwin main.go
	GOARCH=amd64 GOOS=linux go build -o ${BINARY_NAME}-linux main.go
	GOARCH=amd64 GOOS=window go build -o ${BINARY_NAME}-windows main.go

all: compile


clean:
	@rm -f bin/*