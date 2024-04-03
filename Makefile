APP=$(shell basename -s .git `git remote get-url origin`)
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=skymage
LINUXOS=linux
WINDOWSOS=windows
TARGETARCH=amd64
MACOS=darwin

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
	docker build --build-arg BUILD_PLATFORM=build_linux -t ${REGISTRY}/${APP}:${VERSION}-${LINUXOS}-${TARGETARCH} .

windows:
	docker build --build-arg BUILD_PLATFORM=build_windows -t ${REGISTRY}/${APP}:${VERSION}-${WINDOWSOS}-${TARGETARCH} .

macos:
	docker build --build-arg BUILD_PLATFORM=build_macos -t ${REGISTRY}/${APP}:${VERSION}-${MACOS}-${TARGETARCH} .

push_linux:
	docker push ${REGISTRY}/${APP}:${VERSION}-${LINUXOS}-${TARGETARCH}

push_windows:
	docker push ${REGISTRY}/${APP}:${VERSION}-${WINDOWSOS}-${TARGETARCH}

push_macos:
	docker push ${REGISTRY}/${APP}:${VERSION}-${MACOS}-${TARGETARCH}

remove_linux:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${LINUXOS}-${TARGETARCH}

remove_windows:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${WINDOWSOS}-${TARGETARCH}

remove_macos:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${MACOS}-${TARGETARCH}

clean:
	rm -rf kbot