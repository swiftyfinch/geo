extension String {
    func oneline(withTail tail: String = "…") -> String {
        let lines = components(separatedBy: .newlines)
        return lines.count > 1 ? "\(lines[0])\(tail)" : self
    }
}
