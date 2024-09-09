import Foundation

enum GeoError: LocalizedError {
    case plain(String)
    case combined([LocalizedError])
    case exit
    case uncaughtSignal

    var errorDescription: String? {
        switch self {
        case let .plain(message):
            return message
        case let .combined(errors):
            return errors
                .compactMap(\.errorDescription)
                .joined(separator: "\n")
        case .exit, .uncaughtSignal:
            return nil
        }
    }
}
