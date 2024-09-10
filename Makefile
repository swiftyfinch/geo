.PHONY: install
install:
	swift build --arch arm64 -c release
	cp -f `swift build --arch arm64 -c release --show-bin-path`/geo ~/.local/bin/geo
