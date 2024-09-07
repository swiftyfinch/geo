import Foundation
import Rainbow

@main
struct GeoCLT {
    static func main() throws {
        let clt = GeoCLT(vault: Vault())
        do {
            try clt.run(arguments: CommandLine.arguments)
        } catch {
            var standardError = FileHandle.standardError
            fflush(stdout) // We need to flush the print buffer before printing errors here.
            print("✖︎".red, error.localizedDescription.red, to: &standardError)
            exit(EXIT_FAILURE)
        }
    }

    // MARK: - Instance

    private let vault: Vault
    private let helpMessage = """
    The tiny tool for orchestrating shell tasks based on the running location.
    """
}

// MARK: - Instance Methods

extension GeoCLT {
    private func run(arguments: [String]) throws {
        let arguments = Array(arguments.dropFirst())
        if arguments.count > 0, ["-h", "--help"].contains(arguments[0]) {
            return print(helpMessage)
        }
        if arguments.count > 0, arguments[0].hasPrefix("-") {
            throw GeoError.plain("Unknown command '\(arguments[0])'.")
        }

        let core = Core(
            gatherer: vault.gatherer,
            commandRunner: vault.commandRunner,
            treePrinter: vault.treePrinter,
            defaultNamespace: vault.defaultNamespace
        )
        let storage = try core.gatherGeo()
        guard !storage.isEmpty else { return print("There are no any '.geo*' file.") }

        if arguments.isEmpty {
            print(core.list(storage: storage))
        } else {
            let (name, namespace) = parse(arguments: arguments, storage: storage)
            // Try to print a list of commands from the namespace.
            if namespace == nil, let namespace = storage.get(namespace: name) {
                return print(core.list(namespace: name, commands: namespace))
            }
            guard let namespace, let geo = storage.get(name: name, namespace: namespace) else {
                return print("Can't find geo with name: '\(name)'.")
            }
            try core.run(geo, namespace: namespace, storage: storage)
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
