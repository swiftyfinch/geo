import Fish
import Foundation

enum GeoGathererError: LocalizedError {
    case invalid(String)

    var errorDescription: String? {
        switch self {
        case let .invalid(message):
            return message
        }
    }
}

final class GeoGatherer {
    private let finder: GeoFinder
    private let parser: GeoParser
    private let locationPrefix: String
    private let defaultNamespace: String
    private let fileExtension: String

    init(finder: GeoFinder,
         parser: GeoParser,
         locationPrefix: String,
         defaultNamespace: String,
         fileExtension: String) {
        self.finder = finder
        self.parser = parser
        self.locationPrefix = locationPrefix
        self.defaultNamespace = defaultNamespace
        self.fileExtension = fileExtension
    }

    func gather() throws -> GeoStorage {
        let paths = try finder.findRecursively(at: Folder.current.path)
        let namespaces: GeoNamespaces = try paths.reduce(into: [:]) { map, path in
            let commands = try parser.parseFile(at: path)
            guard !commands.isEmpty else { return } // Skip namespaces with empty commands.

            let namespace = try namespace(path: path)
            map[namespace, default: [:]].merge(commands, uniquingKeysWith: { _, rhs in rhs })
        }
        try validate(namespaces: namespaces)
        return GeoStorage(namespaces: namespaces)
    }

    private func namespace(path: String) throws -> String {
        let file = try File.at(path)
        let suffix = file.name
            .trimmingPrefix("\(locationPrefix).")
            .dropLast(".\(fileExtension)".count)
        return suffix.isEmpty ? defaultNamespace : String(suffix)
    }

    private func validate(namespaces: GeoNamespaces) throws {
        var errors: [LocalizedError] = []
        // Commands in the default namespace cannot have a name that is the same as any other namespace.
        if let defaultNamespace = namespaces[defaultNamespace] {
            let commandCollisions = defaultNamespace.keys.filter { namespaces[$0] != nil }
            errors += commandCollisions.map {
                GeoGathererError.invalid("The command '\($0) collides with the namespace.'")
            }
        }
        guard errors.isEmpty else { throw GeoError.combined(errors) }
    }
}
