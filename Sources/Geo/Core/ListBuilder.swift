final class ListBuilder {
    private let treePrinter: TreePrinter
    private let defaultNamespace: String

    init(treePrinter: TreePrinter,
         defaultNamespace: String) {
        self.treePrinter = treePrinter
        self.defaultNamespace = defaultNamespace
    }

    func buildList(storage: GeoStorage, namespace: GeoMap? = nil) -> String {
        let tree: TreeNode
        if let namespace {
            tree = buildTree(namespace: namespace)
        } else {
            tree = buildTree(storage: storage)
        }
        let list = treePrinter.print(tree, showHelp: false)
        let maxWidth = list.components(separatedBy: .newlines).map(\.raw.count).max()
        return treePrinter.print(tree, showHelp: true, maxWidth: maxWidth)
    }

    private func buildTree(storage: GeoStorage) -> TreeNode {
        let tree = TreeNode(name: ".")
        let sortedIterator = storage.sorted { $0.namespace < $1.namespace }
        for (namespace, commands) in sortedIterator {
            let sortedCommands = commands.sorted { $0.key < $1.key }
            let children = sortedCommands.map { TreeNode(name: $0.key, help: $0.value.help ?? "") }
            if namespace == defaultNamespace {
                tree.children += children
            } else {
                tree.children.append(TreeNode(name: namespace, children: children))
            }
        }
        return tree
    }

    private func buildTree(namespace: GeoMap) -> TreeNode {
        let tree = TreeNode(name: ".")
        let sortedCommands = namespace.sorted { $0.key < $1.key }
        tree.children += sortedCommands.map { TreeNode(name: $0.key, help: $0.value.help ?? "") }
        return tree
    }
}
