import Rainbow

final class TreeNode {
    let name: String
    let help: String?
    var children: [TreeNode]

    init(name: String, help: String? = nil, children: [TreeNode] = []) {
        self.name = name
        self.help = help
        self.children = children
    }
}

final class TreePrinter {
    private let labelStyle: ColorType = .named(.green)
    private let arrowsStyle: ColorType = .named(.green)
    private let infoStyle: ColorType = .named(.lightBlack)
    private let inMiddle = "├─"
    private let firstInRoot = "╭─"
    private let singleInRoot = "*"
    private let leaf = "╰─"
    private let pipe = "│"

    func print(
        _ tree: TreeNode,
        showHelp: Bool,
        maxWidth: Int? = nil,
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
                showHelp: showHelp,
                maxWidth: maxWidth,
                height: height + 1,
                first: index == 0,
                last: index + 1 == tree.children.count,
                prefix: prefix
            )
            output.append(childOutput)
        }
        if height > 0 {
            let label = tree.name.applyingCodes(labelStyle)
            let arrow = arrow(isFirst: first, isLast: last, height: height)
            let line = (prefix + arrow).applyingCodes(arrowsStyle) + label
            let help = showHelp ? help(tree.help, forLine: line, maxWidth: maxWidth) : ""
            output.insert("\(line)\(help)", at: 0)
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

    private func help(_ help: String?, forLine line: String, maxWidth: Int?) -> String {
        guard let help else { return "" }
        let shiftCount = (maxWidth ?? line.raw.count) - line.raw.count
        let shift = String(repeating: " ", count: shiftCount)
        return "\(shift) # \(help)".applyingCodes(infoStyle)
    }
}
