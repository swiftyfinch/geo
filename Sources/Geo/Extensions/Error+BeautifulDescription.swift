import Foundation

extension Error {
    /// Returns error description in beautiful way.
    var beautifulErrorDescription: String {
        let localizedDescription = (self as? LocalizedError)?.errorDescription
        return localizedDescription ?? String(describing: self)
    }
}
