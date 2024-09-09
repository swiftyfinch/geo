final class GeoArgumentParser {
    enum Kind {
        case help
        case unknown(command: String)
        case list(storage: GeoStorage, namespace: GeoMap?)
        case run(geo: Geo, storage: GeoStorage)
        case noGeoFiles
        case noGeo(name: String)
    }

    private let gatherer: GeoGatherer

    init(gatherer: GeoGatherer) {
        self.gatherer = gatherer
    }

    func parse(command: String, storage: GeoStorage? = nil) throws -> Kind {
        try parse(
            arguments: command.components(separatedBy: " "),
            storage: storage
        )
    }

    func parse(arguments: [String], storage: GeoStorage? = nil) throws -> Kind {
        let arguments = Array(arguments.dropFirst())
        if arguments.count > 0, ["-h", "--help"].contains(arguments[0]) {
            return .help
        } else if arguments.count > 0, arguments[0].hasPrefix("-") {
            return .unknown(command: arguments.joined(separator: " "))
        }

        let storage = try storage ?? gatherer.gather()
        guard !storage.isEmpty else { return .noGeoFiles }

        if arguments.isEmpty {
            return .list(storage: storage, namespace: nil)
        } else {
            let (name, namespace) = parse(arguments: arguments, storage: storage)
            // Try to print a list of commands from the namespace.
            if namespace == nil, let namespace = storage.get(namespace: name) {
                return .list(storage: storage, namespace: namespace)
            }
            guard let namespace, let geo = storage.get(name: name, namespace: namespace) else {
                return .noGeo(name: name)
            }
            return .run(geo: geo, storage: storage)
        }
    }

    private func parse(
        arguments: [String],
        storage: GeoStorage
    ) -> (name: String, namespace: String?) {
        if arguments.count == 1 {
            let name = arguments[0]
            guard storage.get(namespace: name) == nil else { return (name, nil) }

            let namespaces = storage.get(name: name)
            // Get the first command from any namespace if there is only one command with that name.
            let namespace = namespaces.count == 1 ? namespaces.first?.key : nil
            return (name, namespace)
        }
        return (arguments[1], arguments[0])
    }
}
