import Foundation
import Rainbow

@main
struct GeoCLT {
    static func main() throws {
        let clt = GeoCLT(vault: Vault())
        do {
            try clt.run(arguments: CommandLine.arguments)
        } catch {
            fflush(stdout) // We need to flush the print buffer before printing errors here.

            var errorMessage: String?
            switch error {
            case let geoError as GeoError:
                errorMessage = geoError.errorDescription
            default:
                errorMessage = error.beautifulErrorDescription
            }
            if let errorMessage {
                var standardError = FileHandle.standardError
                print("✖︎ \(errorMessage)".red, to: &standardError)
            }

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
        let argumentParser = vault.argumentParser
        let core = Core(
            gatherer: vault.gatherer,
            commandRunner: vault.commandRunner,
            commandTreeIterator: vault.commandTreeIterator,
            listBuilder: vault.listBuilder,
            defaultNamespace: vault.defaultNamespace
        )

        switch try argumentParser.parse(arguments: arguments) {
        case .help:
            print(helpMessage)
        case let .unknown(command):
            throw GeoError.plain("Unknown command: '\(command)'.")
        case let .list(storage, namespace?):
            print(core.list(storage: storage, namespace: namespace))
        case .list(let storage, nil):
            print(core.list(storage: storage))
        case let .run(geo, storage):
            try core.run(geo, storage: storage)
        case .noGeoFiles:
            print("There are no any '\(vault.locationPrefix)*.\(vault.fileExtension)' file.")
        case let .noGeo(name):
            print("Can't find geo with name: '\(name)'.")
        }
    }
}
