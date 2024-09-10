import Fish
import Foundation

final class Core {
    private let gatherer: GeoGatherer
    private let commandRunner: CommandRunner
    private let commandTreeIterator: CommandTreeIterator
    private let listBuilder: ListBuilder
    private let defaultNamespace: String

    init(gatherer: GeoGatherer,
         commandRunner: CommandRunner,
         commandTreeIterator: CommandTreeIterator,
         listBuilder: ListBuilder,
         defaultNamespace: String) {
        self.gatherer = gatherer
        self.commandRunner = commandRunner
        self.commandTreeIterator = commandTreeIterator
        self.listBuilder = listBuilder
        self.defaultNamespace = defaultNamespace
    }

    func list(storage: GeoStorage, namespace: GeoMap? = nil) -> String {
        listBuilder.buildList(storage: storage, namespace: namespace)
    }

    func run(_ geo: Geo, storage: GeoStorage) throws {
        let commands = try commandTreeIterator.traverse(geo, storage: storage)
        try commands.enumerated().forEach { index, command in
            let counter = "[\(index + 1)/\(commands.count)]".green
            print(counter, command.body.oneline())

            do {
                try commandRunner.run(
                    command: command.body,
                    output: command.mods.contains(.quietOutput) ? nil : .standardOutput,
                    errorOutput: command.mods.contains(.silent) ? nil : .standardError
                )
            } catch {
                if !command.mods.contains(.ignoreErrors) { throw error }
            }
        }
    }
}
