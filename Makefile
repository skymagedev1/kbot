APP=$(shell basename -s .git `git remote get-url origin`)
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=skymage
LINUXOS=linux
WINDOWSOS=windows
TARGETARCH=amd64
MACOS=darwin
LINUX_CONTAINER_TAG=${REGISTRY}/${APP}:${VERSION}-${LINUXOS}-${TARGETARCH}
WINDOWS_CONTAINER_TAG=${REGISTRY}/${APP}:${VERSION}-${WINDOWSOS}-${TARGETARCH}
MACOS_CONTAINER_TAG=${REGISTRY}/${APP}:${VERSION}-${MACOS}-${TARGETARCH}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build_linux: format get
	CGO_ENABLED=0 GOOS=${LINUXOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X github.com/skymagedev1/kbot/cmd.appVersion="${VERSION}

build_windows: format get
	CGO_ENABLED=0 GOOS=${WINDOWSOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X github.com/skymagedev1/kbot/cmd.appVersion="${VERSION}

build_macos: format get
	CGO_ENABLED=0 GOOS=${MACOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X github.com/skymagedev1/kbot/cmd.appVersion="${VERSION}

linux:
	docker build --build-arg BUILD_PLATFORM=build_linux -t ${LINUX_CONTAINER_TAG} .

windows:
	docker build --build-arg BUILD_PLATFORM=build_windows -t ${WINDOWS_CONTAINER_TAG} .

macos:
	docker build --build-arg BUILD_PLATFORM=build_macos -t ${MACOS_CONTAINER_TAG} .

image:
	docker build . -t ${LINUX_CONTAINER_TAG}

push_linux:
	docker push ${LINUX_CONTAINER_TAG}

push_windows:
	docker push ${WINDOWS_CONTAINER_TAG}

push_macos:
	docker push ${MACOS_CONTAINER_TAG}

remove_linux:
	docker rmi ${LINUX_CONTAINER_TAG}

remove_windows:
	docker rmi ${WINDOWS_CONTAINER_TAG}

remove_macos:
	docker rmi ${MACOS_CONTAINER_TAG}

clean:
	docker rmi ${LINUX_CONTAINER_TAG}