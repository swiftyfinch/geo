struct CommandModes: OptionSet {
    let rawValue: Int

    static let normal: CommandModes = []
    static let quietOutput = CommandModes(rawValue: 1 << 0)
    static let quietErrorOutput = CommandModes(rawValue: 1 << 1)
    static let silent: CommandModes = [quietOutput, quietErrorOutput]
    static let ignoreErrors = CommandModes(rawValue: 1 << 2)
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
