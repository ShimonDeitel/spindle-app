import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [SpinSession] = []
    @Published var isPro: Bool = false

    static let freeLimit = 8

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("spindle_items.json")
    }()

    init() {
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: SpinSession) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: SpinSession) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: SpinSession) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([SpinSession].self, from: data) {
            items = decoded
        } else {
            items = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static let seedData: [SpinSession] = [
        SpinSession(fiberSource: "Fibersource 1", ply: "Ply 1", yardageOut: 10.0, sessionDate: Date().addingTimeInterval(-86400), notes: "Notes 1"),
        SpinSession(fiberSource: "Fibersource 2", ply: "Ply 2", yardageOut: 20.0, sessionDate: Date().addingTimeInterval(-172800), notes: "Notes 2"),
        SpinSession(fiberSource: "Fibersource 3", ply: "Ply 3", yardageOut: 30.0, sessionDate: Date().addingTimeInterval(-259200), notes: "Notes 3")
    ]
}
