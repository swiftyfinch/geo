final class CommandTreeIterator {
    private let argumentParser: GeoArgumentParser
    private let commandName: String

    init(argumentParser: GeoArgumentParser,
         commandName: String) {
        self.argumentParser = argumentParser
        self.commandName = commandName
    }

    func traverse(_ geo: Geo, storage: GeoStorage) throws -> [Command] {
        var commands: [Command] = []
        try geo.commands.forEach { command in
            if command.body.hasPrefix("\(commandName) ") {
                let kind = try argumentParser.parse(
                    command: command.body,
                    storage: storage
                )
                if case let .run(geo, storage) = kind {
                    commands += try traverse(geo, storage: storage)
                }
            } else {
                commands.append(command)
            }
        }
        return commands
    }
}
