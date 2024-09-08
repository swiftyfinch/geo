final class Vault {
    let defaultNamespace = "."
    private let locationPrefix = ".geo"
    private let fileExtension = "yml"

    private(set) lazy var gatherer = GeoGatherer(
        finder: finder,
        parser: parser,
        locationPrefix: locationPrefix,
        defaultNamespace: defaultNamespace,
        fileExtension: fileExtension
    )
    private(set) lazy var commandRunner = CommandRunner()
    private(set) lazy var treePrinter = TreePrinter()
    private lazy var finder = GeoFinder(
        locationPrefix: locationPrefix,
        fileExtension: fileExtension
    )
    private lazy var parser = GeoParser()
}
