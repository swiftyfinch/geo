# Geo 🐚

```yml
# Lints *.swift files.
lint: swiftlint --strict --quiet

# Builds and prepares binary for release.
release:
- geo lint # Call as dependency in the same geo process
- mkdir -p Release
- swift package clean
- swift build -c release --arch arm64
- cp -f `swift build -c release --arch arm64 --show-bin-path`/geo Release/geo
- strip -rSTx Release/geo
- cd Release && zip -r arm64.zip geo

# Skips stdout.
test0: -fastlane some-command

# Skips stdout and stderr.
test1: =fastlane some-command

# Ignores error.
test1: +fastlane some-command
```

```sh
> geo
.
├─ lint    # Lints *.swift files.
├─ release # Builds and prepares binary for release.
├─ test0   # Skips stdout.
╰─ test1   # Ignores error.

> geo lint
```

```sh
..                           # Recursively
├─ .geo.yml                  # Default namespace
╰─ .                         # The current directory
   ├─ .geo.namespace0.yml    # > geo namespace0 ...
   ╰─ .geo                   # Can be a directory or a file
      ├─ .geo.yml            # Default namespace
      ╰─ .geo.namespace1.yml # > geo namespace1 ...
```
