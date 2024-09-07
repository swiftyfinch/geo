import Foundation

enum CommandRunnerError: LocalizedError {
    case missingShellEnv

    var errorDescription: String? {
        switch self {
        case .missingShellEnv:
            return "Missing $\(String.shell) environment variable."
        }
    }
}

final class CommandRunner {
    private typealias Error = CommandRunnerError

    func run(command: String) throws {
        guard let shell = ProcessInfo.processInfo.environment[.shell] else {
            throw Error.missingShellEnv
        }

        let process = Process()
        process.executableURL = URL(filePath: shell)
        process.arguments = ["-c", command]
        try process.run()
        process.waitUntilExit()
    }
}

private extension String {
    static let shell = "SHELL"
}