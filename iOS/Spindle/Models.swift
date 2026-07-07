import Foundation

struct SpinSession: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var fiberSource: String
    var ply: String
    var yardageOut: Double
    var sessionDate: Date
    var notes: String

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        fiberSource: String = "",
        ply: String = "",
        yardageOut: Double = 0,
        sessionDate: Date = Date(),
        notes: String = ""
    ) {
        self.id = id
        self.createdAt = createdAt
        self.fiberSource = fiberSource
        self.ply = ply
        self.yardageOut = yardageOut
        self.sessionDate = sessionDate
        self.notes = notes
    }
}
