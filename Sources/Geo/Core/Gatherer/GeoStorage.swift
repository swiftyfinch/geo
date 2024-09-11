typealias GeoNamespaces = [String: GeoMap]

struct GeoStorage {
    private var namespaces: GeoNamespaces

    init(namespaces: GeoNamespaces) {
        self.namespaces = namespaces
    }

    var isEmpty: Bool { namespaces.isEmpty }

    func get(name: String, namespace: String) -> Geo? {
        namespaces[namespace]?[name]
    }

    func get(name: String) -> GeoNamespaces {
        namespaces.filter { $0.value.keys.contains(name) }
    }

    func get(namespace: String) -> GeoMap? {
        namespaces[namespace]
    }
}

extension GeoStorage: IteratorProtocol, Sequence, Collection {
    typealias Index = GeoNamespaces.Index
    typealias Element = GeoNamespaces.Element

    var startIndex: Index { namespaces.startIndex }
    var endIndex: Index { namespaces.endIndex }

    subscript(index: Index) -> Element { namespaces[index] }

    func index(after index: Index) -> Index {
        namespaces.index(after: index)
    }

    mutating func next() -> GeoNamespaces.Element? {
        var iterator = namespaces.makeIterator()
        return iterator.next()
    }
}
