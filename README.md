# Geo 🐚

The tiny tool for managing shell task shortcuts based on the current directory.

<br>

## Motivation

Usually, we have a few basic shell commands that are dependent on the repository. \
It can be running `lint` or `tests`, etc.
```sh
> swiftlint ...
> xcodebuild test ...
```
Additionally, these can be used within a monorepo by different teams, each with their own set of commands. \
I have not found an existing tool that meets my needs for this task, so I have decided to create my own.

### Geo Philosophy

`*` The task format should be as compact and simple as possible; \
`*` It is just a tool for creating shortcuts, not for implementing them. \
    All scripts should be stored in separate files, and then called from this tool using specific arguments; \
`*` It should be possible to `manually call` without this tool if necessary.

### What makes it different?

`+` Describes all tasks in a single file or separate files for each team; \
`+` Collects tasks from the root directory `/` to the current one; \
`+` A simple file format based on `YAML`, which does not support any specific programming language; \
`+` Supports calling one task from another at any time; \
`+` Prints a list of all tasks in a tree format.

<br>

## How to install 📦

```sh
curl -Ls http://swiftyfinch.github.io/geo/install.sh | bash
```

<br>

## How to use

If you don't need to split tasks into separate files for each team, you can just create a single `.geo.yml` file in your repository:
```sh
.
╰─ .geo.yml # Single file without namespaces
```

Otherwise, create a folder called `.geo` and place a file `*.yml` for each team in it:
```sh
.
╰─ .geo # Folder
   ├─ charlie.yml # Namespace: charlie
   ╰─ bravo.yml # Namespace: bravo
```

### File Format

Describe your commands in the following format:
```yaml
# Description
task_name: [String] or String
```

For example:
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
```

Then you can get a list of your commands:
```sh
> geo
.
├─ lint    # Lints *.swift files.
╰─ release # Builds and prepares binary for release.
```

And finally, run the following command:
```sh
> geo lint
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
