import Fish
import Foundation

final class Core {
    private let gatherer: GeoGatherer
    private let commandRunner: CommandRunner
    private let commandTreeIterator: CommandTreeIterator
    private let treePrinter: TreePrinter
    private let defaultNamespace: String

    init(gatherer: GeoGatherer,
         commandRunner: CommandRunner,
         commandTreeIterator: CommandTreeIterator,
         treePrinter: TreePrinter,
         defaultNamespace: String) {
        self.gatherer = gatherer
        self.commandRunner = commandRunner
        self.commandTreeIterator = commandTreeIterator
        self.treePrinter = treePrinter
        self.defaultNamespace = defaultNamespace
    }

    func list(storage: GeoStorage) -> String {
        let tree = TreeNode(name: ".")
        let sortedIterator = storage.sorted { $0.namespace < $1.namespace }
        for (namespace, commands) in sortedIterator {
            let sortedCommands = commands.sorted { $0.key < $1.key }
            let children = sortedCommands.map { TreeNode(name: $0.key, info: $0.value.help) }
            if namespace == defaultNamespace {
                tree.children += children
            } else {
                tree.children.append(TreeNode(name: namespace, children: children))
            }
        }
        return treePrinter.print(tree)
    }

    func list(namespace: GeoMap) -> String {
        let tree = TreeNode(name: ".")
        let sortedCommands = namespace.sorted { $0.key < $1.key }
        tree.children += sortedCommands.map { TreeNode(name: $0.key, info: $0.value.help) }
        return treePrinter.print(tree)
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
