.PHONY: \
	all \
	staticcheck \
	fmtcheck \
	pretest \
	test \
	integration

DEP_TOOL ?= dep

all: test

staticcheck:
	@ cd /tmp && go get -v honnef.co/go/tools/cmd/staticcheck
	staticcheck ./...

fmtcheck:
	if [ -z "$${SKIP_FMT_CHECK}" ]; then [ -z "$$(gofmt -s -d *.go ./testing | tee /dev/stderr)" ]; fi

testdeps:
ifeq ($(DEP_TOOL), dep)
	GOMODULE111=off go get -u github.com/golang/dep/cmd/dep
	dep ensure -v
else
	go mod download
endif

pretest: testdeps staticcheck fmtcheck

gotest:
	go test -race ./...

test: pretest gotest

integration:
	go test -tags docker_integration -run TestIntegration -v
