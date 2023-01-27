
import UIKit

final class MainView: UIView {    
    
    weak var delegate: MainViewOutputProtocol?
    var noteManager = NoteManager()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addCellButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .systemBackground
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        addCellButton.addTarget(self, action: #selector(addTableButtonPressed), for: .touchUpInside)
        
        configViewComponents()
    }
    
    @objc
    private func addTableButtonPressed() {
        
        delegate?.addTableButtonPressed()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ManeViewConstraints
extension MainView {
    private func configViewComponents() {
        
        addSubview(tableView)
        addSubview(addCellButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 3),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            addCellButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addCellButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            addCellButton.widthAnchor.constraint(equalToConstant: 40),
            addCellButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
