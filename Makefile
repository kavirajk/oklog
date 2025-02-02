SHELL:=/usr/bin/env bash -o pipefail

# Adapted from https://www.thapaliya.com/en/writings/well-documented-makefiles/
# .PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-45s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := build

# Golang environment
GOOS               ?= $(shell go env GOOS)
GOHOSTOS           ?= $(shell go env GOHOSTOS)
GOARCH             ?= $(shell go env GOARCH)
GOARM              ?= $(shell go env GOARM)
GOEXPERIMENT       ?= $(shell go env GOEXPERIMENT)
CGO_ENABLED        := 0
GO_ENV             := GOEXPERIMENT=$(GOEXPERIMENT) GOOS=$(GOOS) GOARCH=$(GOARCH) GOARM=$(GOARM) CGO_ENABLED=$(CGO_ENABLED)
GOTEST             ?= go test


GO_FLAGS           := -ldflags "-extldflags \"-static\" -s -w $(GO_LDFLAGS)" -tags netgo
DYN_GO_FLAGS       := -ldflags "-s -w $(GO_LDFLAGS)" -tags netgo

# build
.PHONY: build clean test

build:				## Builds oklog binary (./bin/oklog)
	CGO_ENABLED=0 go build $(GO_FLAGS) -o bin/oklog ./cmd/oklog
clean:				## Clean the builds
	rm -rf ./bin
test:				## Run all the tests
	$(GOTEST) ./...
