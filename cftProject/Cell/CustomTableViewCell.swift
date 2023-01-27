
import UIKit

final class CustomTableViewCell: UITableViewCell {
    
    weak var cellTaskDelegate: TaskButtonProtocol?
    var index: IndexPath?
    
    static let identifier = "CustomTableViewCell"
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.systemTeal.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel = UILabel(text: "")
    
    let descriptionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setImage(UIImage(systemName: "list.bullet.rectangle"), for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemGray6
        selectionStyle = .none
        
        checkButton.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        descriptionButton.addTarget(self, action: #selector(descriptionButtonAction), for: .touchUpInside)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func checkButtonAction() {
        guard let index = index else { return }
        cellTaskDelegate?.readyButtonTapped(indexPath: index)
    }
    
    @objc
    private func descriptionButtonAction() {
        guard let index = index else { return }
        cellTaskDelegate?.descriptionButtonAction(indexPath: index)
    }
    
    // MARK: - Functions
    func prepare(with note: NoteModel) {
        nameLabel.text = note.title
        dateLabel.text = note.date
        
        if note.noteReady {
            checkButton.backgroundColor = .systemGreen
        } else {
            checkButton.backgroundColor = .systemBackground
        }
        
        switch note.segmentContrId {
        case 0: nameLabel.textColor = .systemRed
        case 1: nameLabel.textColor = .label
        case 2: nameLabel.textColor = .systemYellow
        default:
            break
        }
    }
}

//MARK: Add ConstraintsCell
extension CustomTableViewCell {
    private func setConstraints(){
        contentView.addSubview(checkButton)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(descriptionButton)
        
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkButton.heightAnchor.constraint(equalToConstant: 28),
            checkButton.widthAnchor.constraint(equalToConstant: 28),
        
            nameLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 23),
            
            dateLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionButton.topAnchor.constraint(equalTo: topAnchor),
            descriptionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionButton.widthAnchor.constraint(equalToConstant: 70),
            descriptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
    }
}
