final class Vault {
    let commandName = "geo"
    let defaultNamespace = "."
    let locationPrefix = ".geo"
    let fileExtension = "yml"

    private(set) lazy var gatherer = GeoGatherer(
        finder: finder,
        parser: parser,
        locationPrefix: locationPrefix,
        defaultNamespace: defaultNamespace,
        fileExtension: fileExtension
    )
    private(set) lazy var commandRunner = CommandRunner()
    private(set) lazy var treePrinter = TreePrinter()
    private(set) lazy var argumentParser = GeoArgumentParser(
        gatherer: gatherer
    )
    private(set) lazy var commandTreeIterator = CommandTreeIterator(
        argumentParser: argumentParser,
        commandName: commandName
    )
    private lazy var finder = GeoFinder(
        locationPrefix: locationPrefix,
        fileExtension: fileExtension
    )
    private lazy var parser = GeoParser()
}
