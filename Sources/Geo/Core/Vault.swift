final class Vault {
    let defaultNamespace = "."
    private let locationPrefix = ".geo"

    private(set) lazy var gatherer = GeoGatherer(
        finder: finder,
        parser: parser,
        locationPrefix: locationPrefix,
        defaultNamespace: defaultNamespace
    )
    private(set) lazy var commandRunner = CommandRunner()
    private(set) lazy var treePrinter = TreePrinter()
    private lazy var finder = GeoFinder(locationPrefix: locationPrefix)
    private lazy var parser = GeoParser()
}
