
import Foundation

final class NoteManager {
    
    private let dataSourceURL: URL
    private var allNotes: [NoteModel] {
        get {
            do {
                let decoder = PropertyListDecoder()
                let data = try Data(contentsOf: dataSourceURL)
                let decodedNotes = try! decoder.decode([NoteModel].self, from: data)
                
                return decodedNotes
            } catch {
                return []
            }
        }
        set {
            do {
                let encoder = PropertyListEncoder()
                let data = try encoder.encode(newValue)
                
                try data.write(to: dataSourceURL)
            } catch {
                
            }
        }
    }
    
    // MARK: - Life Cycle
    init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let notesPath = documentsPath.appendingPathComponent("notes").appendingPathExtension("plist")
        
        dataSourceURL = notesPath
    }
    
    // MARK: - Functions
    func getAllNotes() -> [NoteModel] {
        return allNotes
    }
    
    func create(note: NoteModel) {
        allNotes.insert(note, at: 0)
    }
    
    func setComplete(note: NoteModel, index: Int) {
        allNotes[index] = note
    }
    
    func delete(note: NoteModel) {
        if let index = allNotes.firstIndex(where: { $0.id == note.id }) {
            allNotes.remove(at: index)
        }
    }
    
    func noteReadyButtonPressed(model: NoteModel, bool: Bool, index: Int) {
        allNotes[index].noteReady = bool
    }
}
