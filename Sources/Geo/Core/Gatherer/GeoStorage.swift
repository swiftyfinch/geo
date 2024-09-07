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

extension GeoStorage: IteratorProtocol, Sequence {
    mutating func next() -> (namespace: String, commands: GeoMap)? {
        guard let first = namespaces.keys.first,
              let namespace = namespaces.removeValue(forKey: first) else { return nil }
        return (first, namespace)
    }
}
