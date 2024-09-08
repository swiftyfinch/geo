# Runs SwiftFormat and SwiftLint.
lint:
- "which swiftformat >/dev/null || (printf '\e[31m⛔️ Could not find SwiftFormat.\e[m\n\e[33m🚑 Run: brew install swiftformat\e[m\n' && exit 1)"
- "which swiftlint >/dev/null || (printf '\e[31m⛔️ Could not find SwiftLint.\e[m\n\e[33m🚑 Run: brew install swiftlint\e[m\n' && exit 1)"
- swiftformat --quiet .
- swiftlint --fix --quiet
- swiftlint --strict --quiet

# Builds and installs release Geo version.
install:
- swift build --arch arm64 -c release
- cp -f `swift build --arch arm64 -c release --show-bin-path`/geo ~/.local/bin/geo

# Builds and prepares binaries for release.
release:
- mkdir -p Release

- swift package clean
- swift build -c release --arch x86_64
- cp -f `swift build -c release --arch x86_64 --show-bin-path`/geo Release/geo
- strip -rSTx Release/geo
- cd Release && zip -r x86_64.zip geo
- cd Release && mv geo geo-x86_64

- swift package clean
- swift build --arch arm64 -c release
- cp -f `swift build -c release --arch arm64 --show-bin-path`/geo Release/geo
- strip -rSTx Release/geo
- cd Release && zip -r arm64.zip geo
- cd Release && mv geo geo-arm64
