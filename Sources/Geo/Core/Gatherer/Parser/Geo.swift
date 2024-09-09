struct CommandModes: OptionSet {
    let rawValue: Int

    static let normal: CommandModes = []
    static let silent = CommandModes(rawValue: 1)
}

struct Command {
    let body: String
    let mods: CommandModes
}

struct Geo {
    let commands: [Command]
    let help: String?

    init(
        commands: [Command],
        help: String? = nil
    ) {
        self.commands = commands
        self.help = help
    }
}
