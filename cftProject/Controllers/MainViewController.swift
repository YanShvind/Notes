
import UIKit

final class MainViewController: UIViewController {
    
    var noteManager = NoteManager()
    
    private let createView: MainView = {
        let view = MainView()
        return view
    }()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createView.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notes"
        self.view.backgroundColor = .systemBackground
        
        createView.tableView.delegate = self
        createView.tableView.dataSource = self
        
        createView.delegate = self
                
        zeroNotesFalse()
    }
    
    override func loadView() {
        
        self.view = createView
    }
    
    private func zeroNotesFalse() {
        if noteManager.getAllNotes().count == 0 {
            let note = NoteModel(title: "Hello", description: "Welcome!!!", date: "Your Date", photoImage: "")
            noteManager.create(note: note)
        }
    }
}

//MARK: ManeViewOutputProtocol
extension MainViewController: MainViewOutputProtocol {
    func addTableButtonPressed() {
        let controller = AddNewCellViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteManager.getAllNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        
        cell.cellTaskDelegate = self
        cell.index = indexPath
        let note = noteManager.getAllNotes()[indexPath.row]
        cell.prepare(with: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
                
        let controller = ChangeDataViewController(index: indexPath.row)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let noteToDelete = noteManager.getAllNotes()[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completed) in
            completed(true)
            self.noteManager.delete(note: noteToDelete)
            tableView.reloadData()
        }
        
        let changeAction = UIContextualAction(style: .destructive, title: "Change") { (_, _, completed) in
            completed(true)
            let controller = ChangeDataViewController(index: indexPath.row)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        changeAction.backgroundColor = .systemYellow
        
        return UISwipeActionsConfiguration(actions: [deleteAction, changeAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = noteManager.getAllNotes()[indexPath.row]
        
        let okAction = UIContextualAction(style: .normal, title: "Ok"){(_, _, completionHandler) in
            self.noteManager.noteReadyButtonPressed(model: editingRow, bool: !editingRow.noteReady, index: indexPath.row)
            tableView.reloadData()
        }
        okAction.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [okAction])
    }
}

//MARK: PressReadyTaskButton, descriptionButtonAction
extension MainViewController: TaskButtonProtocol {
    func readyButtonTapped(indexPath: IndexPath) {
        let note = noteManager.getAllNotes()[indexPath.row]
        noteManager.noteReadyButtonPressed(model: note, bool: !note.noteReady, index: indexPath.row)
        createView.tableView.reloadData()
    }
    
    func descriptionButtonAction(indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            let popUp = PopUpDescription()
            popUp.index = indexPath.row
            self.view.addSubview(popUp)
        }
    }
}

