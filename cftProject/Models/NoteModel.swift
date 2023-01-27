
import Foundation

struct NoteModel: Codable {
        
    // MARK: - Properties
    var id = UUID().uuidString
    var title: String
    var description: String
    var date: String
    var noteReady: Bool = false
    var segmentContrId: Int = 1
    var photoImage: String
}

