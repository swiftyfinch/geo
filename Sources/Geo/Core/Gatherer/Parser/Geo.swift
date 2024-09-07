struct Geo {
    let commands: [String]
    let help: String?
    let dependencies: [String]

    init(
        commands: [String],
        help: String? = nil,
        dependencies: [String] = []
    ) {
        self.commands = commands
        self.help = help
        self.dependencies = dependencies
    }
}
