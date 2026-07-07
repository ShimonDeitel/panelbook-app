import Foundation

struct Panel: Identifiable, Codable, Equatable {
    let id: UUID
    var dateCreated: Date
    var title: String
    var pieceCount: Double
    var glassColors: String
    var cameFootage: Double
    var patternSource: String

    init(id: UUID = UUID(), dateCreated: Date = Date(), title: String = "", pieceCount: Double = 0, glassColors: String = "", cameFootage: Double = 0, patternSource: String = "") {
        self.id = id
        self.dateCreated = dateCreated
        self.title = title
        self.pieceCount = pieceCount
        self.glassColors = glassColors
        self.cameFootage = cameFootage
        self.patternSource = patternSource
    }
}
