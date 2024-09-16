import Fish
import Yams

typealias GeoMap = [String: Geo]

final class GeoParser {
    func parseFile(at path: String) throws -> GeoMap {
        let content = try File.read(at: path)
        let yaml = try Yams.load(yaml: content)
        guard let root = yaml as? [String: Any] else { return [:] }

        let commandHelps = parseHelp(in: content)
        return root.reduce(into: [:]) { tasks, element in
            let name = element.key
            let help = commandHelps[name]
            let rawCommands: [String]
            if let string = element.value as? String {
                rawCommands = [string]
            } else if let array = element.value as? [String] {
                rawCommands = array
            } else {
                return
            }
            let commands = rawCommands.map { command in
                let (mods, command) = parseMods(command: command)
                return Command(body: command, mods: mods)
            }
            tasks[element.key] = Geo(
                commands: commands,
                help: help
            )
        }
    }

    private func parseHelp(in content: String) -> [String: String] {
        // # Some command description
        // command_name:
        let matches = content.matches(of: #/^# (?<help>.*)(\n| )(?<command>.*):($| )/#.anchorsMatchLineEndings())
        return matches.reduce(into: [:]) { commandHelps, match in
            let (command, help) = (match.output.command, match.output.help)
            commandHelps[String(command)] = String(help)
        }
    }

    private func parseMods(command: String) -> (mods: CommandModes, command: String) {
        var command = command
        var mods: CommandModes = []
        let availableMods: [Character: CommandModes] = [
            "-": .quietOutput,
            "=": .silent,
            "+": .ignoreErrors
        ]
        while let first = command.first,
              let mode = availableMods[first] {
            mods.insert(mode)
            command.removeFirst()
        }
        return (mods, command)
    }
}

private enum Keys {
    static let run = "run"
    static let help = "help"
    static let needs = "needs"
}
