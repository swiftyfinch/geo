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
        var geoFiles: [IFile] = []
        let folder = try Folder.at(path)
        if let geoFolder = try? Folder.at(folder.subpath(locationPrefix)) {
            geoFiles = try geoFolder.files()
                .filter { $0.pathExtension == fileExtension }
                .filter { !$0.name.hasPrefix(".") && !$0.name.hasPrefix(locationPrefix) }
        } else {
            let geoFile = try folder.files()
                .first { $0.name == "\(locationPrefix).\(fileExtension)" }
            geoFiles = geoFile.map { [$0] } ?? []
        }
        return geoFiles.map(\.path).sorted(by: <)
    }
}

extension String {
    static let root = "/"
}
