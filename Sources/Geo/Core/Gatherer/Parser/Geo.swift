struct Geo {
    let name: String
    let commands: [String]
    let help: String?

    init(
        name: String,
        commands: [String],
        help: String? = nil
    ) {
        self.name = name
        self.commands = commands
        self.help = help
    }
}
