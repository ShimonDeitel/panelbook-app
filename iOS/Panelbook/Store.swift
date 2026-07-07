import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Panel] = []
    @Published var isPro: Bool = false

    static let freeLimit = 12

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("panelbook_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            items = [
            Panel(title: "Panel title 1", pieceCount: 10, glassColors: "Glass colors 1", cameFootage: 10, patternSource: "Pattern source 1"),
            Panel(title: "Panel title 2", pieceCount: 13, glassColors: "Glass colors 2", cameFootage: 13, patternSource: "Pattern source 2"),
            Panel(title: "Panel title 3", pieceCount: 16, glassColors: "Glass colors 3", cameFootage: 16, patternSource: "Pattern source 3")
            ]
            save()
        }
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Panel) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Panel) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Panel) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Panel].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
