import Rainbow

final class TreeNode {
    let name: String
    let info: String?
    var children: [TreeNode]

    init(name: String, info: String? = nil, children: [TreeNode] = []) {
        self.name = name
        self.info = info
        self.children = children
    }
}

final class TreePrinter {
    private let labelStyle: ColorType = .named(.green)
    private let arrowsStyle: ColorType = .named(.green)
    private let infoStyle: ColorType = .named(.lightBlack)
    private let inMiddle = "├─"
    private let firstInRoot = "╭─"
    private let singleInRoot = "──"
    private let leaf = "╰─"
    private let pipe = "│"

    func print(
        _ tree: TreeNode,
        height: Int = 0,
        first: Bool = false,
        last: Bool = false,
        prefix: String = ""
    ) -> String {
        var output: [String] = []
        for (index, child) in tree.children.enumerated() {
            var prefix = prefix
            if height > 0 { prefix += last ? "   " : "\(pipe)  " }
            let childOutput = print(
                child,
                height: height + 1,
                first: index == 0,
                last: index + 1 == tree.children.count,
                prefix: prefix
            )
            output.append(childOutput)
        }
        if height > 0 {
            let label = tree.name.applyingCodes(labelStyle)
            let info = tree.info.map { " # \($0)".applyingCodes(infoStyle) } ?? ""
            let arrow = arrow(isFirst: first, isLast: last, height: height)
            output.insert((prefix + arrow).applyingCodes(arrowsStyle) + "\(label)\(info)", at: 0)
        }
        return output.joined(separator: "\n")
    }

    private func arrow(isFirst: Bool, isLast: Bool, height: Int) -> String {
        if height == 0 {
            return ""
        } else if height == 1 && isFirst && isLast {
            return "\(singleInRoot) "
        } else if height == 1 && isFirst {
            return "\(firstInRoot) "
        } else if isLast {
            return "\(leaf) "
        }
        return "\(inMiddle) "
    }
}
