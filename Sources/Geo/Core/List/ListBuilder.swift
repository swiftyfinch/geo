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
        let showRootLabel: Bool
        if let namespace {
            showRootLabel = false
            tree = buildTree(namespace: namespace)
        } else if storage.count == 1, let namespace = storage.first, namespace.key != defaultNamespace {
            showRootLabel = true
            tree = buildTree(name: namespace.key, namespace: namespace.value)
        } else {
            showRootLabel = false
            tree = buildTree(storage: storage)
        }
        let list = treePrinter.print(tree, showHelp: false, showRootLabel: showRootLabel)
        let maxWidth = list.components(separatedBy: .newlines).map(\.raw.count).max()
        return treePrinter.print(tree, showHelp: true, helpPosition: maxWidth, showRootLabel: showRootLabel)
    }

    private func buildTree(storage: GeoStorage) -> TreeNode {
        let tree = TreeNode(name: ".")
        let sortedIterator = storage.sorted { $0.key < $1.key }
        for (namespace, commands) in sortedIterator {
            let sortedCommands = commands.sorted { $0.key < $1.key }
            let children = sortedCommands.compactMap {
                buildTreeNode(name: $0.key, geo: $0.value)
            }
            if namespace == defaultNamespace {
                tree.children += children
            } else {
                tree.children.append(TreeNode(name: namespace, children: children))
            }
        }
        return tree
    }

    private func buildTree(name: String? = nil, namespace: GeoMap) -> TreeNode {
        let tree = TreeNode(name: name ?? ".")
        let sortedCommands = namespace.sorted { $0.key < $1.key }
        tree.children += sortedCommands.compactMap {
            buildTreeNode(name: $0.key, geo: $0.value)
        }
        return tree
    }

    private func buildTreeNode(name: String, geo: Geo) -> TreeNode? {
        guard let help = geo.help else { return TreeNode?.none }
        return TreeNode(name: name, help: help)
    }
}
