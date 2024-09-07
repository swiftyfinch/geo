import Fish
import Yams

typealias GeoMap = [String: Geo]

final class GeoParser {
    func parseFile(at path: String) throws -> GeoMap {
        let content = try File.read(at: path)
        let yaml = try Yams.load(yaml: content)
        guard let root = yaml as? [String: [String: Any]] else { return [:] }

        return root.reduce(into: [:]) { tasks, element in
            let commands: [String]
            let anyCommands = element.value[Keys.run]
            if let stringCommands = anyCommands as? [String] {
                commands = stringCommands
            } else if let command = anyCommands as? String {
                commands = [command]
            } else {
                commands = []
            }

            let dependencies: [String]
            let anyDependencies = element.value[Keys.needs]
            if let stringDependencies = anyDependencies as? [String] {
                dependencies = stringDependencies
            } else if let dependency = anyDependencies as? String {
                dependencies = [dependency]
            } else {
                dependencies = []
            }

            guard !commands.isEmpty || !dependencies.isEmpty else { return }

            let help = element.value[Keys.help] as? String
            tasks[element.key] = Geo(
                commands: commands,
                help: help,
                dependencies: dependencies
            )
        }
    }
}

private enum Keys {
    static let run = "run"
    static let help = "help"
    static let needs = "needs"
}
