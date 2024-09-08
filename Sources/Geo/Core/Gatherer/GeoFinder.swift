import Fish

final class GeoFinder {
    private let locationPrefix: String
    private let fileExtension: String

    init(locationPrefix: String,
         fileExtension: String) {
        self.locationPrefix = locationPrefix
        self.fileExtension = fileExtension
    }

    func findRecursively(at path: String) throws -> [String] {
        var paths: [String] = try find(at: path)

        var folder = try Folder.at(path)
        while folder.name != .root, let parent = folder.parent {
            let parentPaths = try find(at: parent.path)
            paths.append(contentsOf: parentPaths)
            folder = parent
        }

        return paths.reversed()
    }

    private func find(at path: String) throws -> [String] {
        var folder = try Folder.at(path)
        let geoFolderPath = folder.subpath(locationPrefix)
        if Folder.isExist(at: geoFolderPath) {
            folder = try Folder.at(geoFolderPath)
        }
        return try folder.files()
            .filter { $0.pathExtension == fileExtension }
            .filter { $0.name.hasPrefix(locationPrefix) }
            .map(\.path)
            .sorted(by: <)
    }
}

extension String {
    static let root = "/"
}
