import Fish
import Foundation

final class Core {
    private let gatherer: GeoGatherer
    private let commandRunner: CommandRunner
    private let treePrinter: TreePrinter
    private let defaultNamespace: String

    init(gatherer: GeoGatherer,
         commandRunner: CommandRunner,
         treePrinter: TreePrinter,
         defaultNamespace: String) {
        self.gatherer = gatherer
        self.commandRunner = commandRunner
        self.treePrinter = treePrinter
        self.defaultNamespace = defaultNamespace
    }

    func gatherGeo() throws -> GeoStorage {
        try gatherer.gather()
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

    func list(namespace _: String, commands: GeoMap) -> String {
        let tree = TreeNode(name: ".")
        let sortedCommands = commands.sorted { $0.key < $1.key }
        tree.children += sortedCommands.map { TreeNode(name: $0.key, info: $0.value.help) }
        return treePrinter.print(tree)
    }

    func run(_ geo: Geo, namespace: String, storage: GeoStorage) throws {
        try geo.dependencies.forEach { name in
            var geo = storage.get(name: name, namespace: namespace)
            if geo == nil {
                // Use the command from any namespace if it is not in the current one.
                let namespaces = storage.get(name: name)
                if namespaces.count == 1, let firstNamespace = namespaces.first?.key {
                    geo = storage.get(name: name, namespace: firstNamespace)
                }
            }
            guard let geo else { return }

            try run(geo, namespace: namespace, storage: storage)
        }
        try geo.commands.forEach { command in
            let lines = command.components(separatedBy: .newlines)
            let title = lines.count > 1 ? "\(lines[0])…" : command
            print(">".bold.yellow, title)
            try commandRunner.run(command: command)
        }
    }
}
