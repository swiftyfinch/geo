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
.
╰─ .geo.yml # Single file without namespaces
```

```sh
.
╰─ .geo
   ├─ a.yml # Namespace: a
   ╰─ b.yml # Namespace: b
```


```sh
/
├─ .geo.yml # General
╰─ Folder0
   ├─ .geo.yml # More specific
   ╰─ Folder1
      ├─ .geo.yml # More specific
      ╰─ .
         ╰─ .geo.yml # More specific
```
