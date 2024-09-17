.PHONY: install
install:
	swift build --arch arm64 -c release
	cp -f `swift build --arch arm64 -c release --show-bin-path`/geo ~/.local/bin/geo

.PHONY: release
release:
	rm -rf Release
	mkdir -p Release

	swift package clean
	swift build -c release --arch x86_64 -Xcc -Os
	cp -f `swift build -c release --arch x86_64 -Xcc -Os --show-bin-path`/geo Release/geo
	strip -rSTx Release/geo
	cd Release && zip -r x86_64.zip geo
	cd Release && mv geo geo-x86_64
	@echo

	swift package clean
	swift build --arch arm64 -c release -Xcc -Os
	cp -f `swift build -c release --arch arm64 -Xcc -Os --show-bin-path`/geo Release/geo
	strip -rSTx Release/geo
	cd Release && zip -r arm64.zip geo
	cd Release && mv geo geo-arm64
	@echo
