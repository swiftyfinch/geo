<p align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/b0249672-e4b1-48fc-baed-46ae4ba924f2" width="500px" />
      <img src="https://github.com/user-attachments/assets/0f06e1e8-e135-4118-8c20-ba3735ce7af0" width="500px" />
    </picture>
    <p align="center">
        <img src="https://img.shields.io/badge/Platform-macOS-2679eb" />
    </p>
</p>

## 🎯 Motivation

Usually, we have a few basic shell commands that are dependent on the repository. \
It can be running `lint` or `tests`, etc.
```sh
> swiftlint ...
> xcodebuild test ...
```
Additionally, these can be used within a monorepo by different teams, each with their own set of commands. \
I have not found an existing tool that meets my needs for this task, so I have decided to create my own.

### Geo Philosophy

`*` The task format should be as `compact` and `simple` as possible; \
`*` It is just a tool for `creating shortcuts`, not for implementing them. \
    All scripts should be stored in separate files, and then called from this tool using specific arguments; \
`*` It should be possible to `manually call` without this tool if necessary.

### What makes it different?

`+` Describes all tasks in a single file or separate files for each team; \
`+` Collects tasks from the root directory `/` to the current one; \
`+` A simple file format based on `YAML`, which does not support any specific programming language; \
`+` Supports calling one task from another at any time; \
`+` Prints a list of all tasks in a tree format.

<br>

## 📦 How to install

```sh
curl -Ls http://swiftyfinch.github.io/geo/install.sh | bash
```

<br>

## 🕹️ How to use

If you don't need to split tasks into separate files for each team, you can just create a single `.geo.yml` file in your repository:
```sh
.
╰─ .geo.yml # Single file without namespaces
```

Otherwise, create a folder called `.geo` and place `*.yml` files for each team in it:
```sh
.
╰─ .geo # Folder
   ├─ taiga.yml # Namespace for 'taiga' team
   ╰─ saiga.yml # Namespace for 'saiga' team
```

### File Format

Describe your commands in the following format:
```yaml
# Description must be here
task_name: [String] or String
```

For example:
```yml
# Lints *.swift files.
lint: swiftlint --strict --quiet

# Formats *.swift files.
format: swiftformat . --lint --quiet

# Lints & formats *.swift files.
tidy: [geo lint, geo format]

# Builds and prepares binary for release.
release:
- geo format # Call as dependency in the same geo process
- geo lint # Call as dependency in the same geo process
- mkdir -p Release
- swift package clean
- swift build -c release --arch arm64
- cp -f `swift build -c release --arch arm64 --show-bin-path`/geo Release/geo
- strip -rSTx Release/geo
- cd Release && zip -r arm64.zip geo
```

> [!NOTE]
> You can call another task like `geo lint` anywhere. \
> It will be called within the same `geo` process, not separately.

Then you can get a list of your commands:
```sh
> geo
╭─ format  # Formats *.swift files.
├─ lint    # Lints *.swift files.
├─ release # Builds and prepares binary for release.
╰─ tidy    # Lints & formats *.swift files.
```

And finally, you can run the described commands:
```sh
> geo lint
[1/1] swiftlint --strict --quiet

> geo format
[1/1] swiftformat . --lint --quiet

> geo tidy
[1/2] swiftlint --strict --quiet
[2/2] swiftformat . --lint --quiet

> geo release
[1/8] swiftformat . --lint --quiet
[2/8] swiftlint --strict --quiet
[3/8] mkdir -p Release
[4/8] swift package clean
[5/8] swift build -c release --arch arm64
[6/8] cp -f `swift build -c release --arch arm64 --show-bin-path`/geo Release/geo
[7/8] strip -rSTx Release/geo
[8/8] cd Release && zip -r arm64.zip geo
```

### Commands hierarhy

You can add commands to different directories and have them all run recursively. \
It can be useful if you want to include some secret commands in your shared list:
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

<br>

## 🤝 Contribution

Feel free [to open a pull request](https://github.com/swiftyfinch/geo/contribute) or [a discussion](https://github.com/swiftyfinch/geo/discussions).

<br>

## 💬 Misc

- Author of Fan Art: https://www.reddit.com/r/HollowKnight/comments/12imdep/geo/.
