
import UIKit

final class ChangeView: UIView {
    
    weak var delegate: ChangeViewSwProtocol?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.artframe")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameNoteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Arial", size: 20)
        textView.backgroundColor = .systemGray6
        textView.text = "Enter note title..."
        textView.textColor = UIColor.label
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Arial", size: 16)
        textView.backgroundColor = .systemGray6
        textView.text = "Enter note description..."
        textView.textColor = UIColor.label
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let makeUpLabel = UILabel(text: "Date:")
    let dateLabel = UILabel(text: "")
    
    private let dateViewColor = UIView(color: .systemGray6)
    
    let switchDate: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemGreen
        mySwitch.tintColor = .darkGray
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Color:"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textColorSegmentControl: UISegmentedControl = {
        var segmentControl = UISegmentedControl()
        let titles = ["", "", ""]
        segmentControl = UISegmentedControl(items: titles)
        segmentControl.selectedSegmentTintColor = .label
        segmentControl.backgroundColor = .systemGray6
        segmentControl.selectedSegmentIndex = 1
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        switchDate.addTarget(self, action: #selector(switchAction2), for: .allTouchEvents)
        textColorSegmentControl.addTarget(self, action: #selector(textColorSegmentControlTapped), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        
        nameNoteTextView.delegate = self
        descriptionTextView.delegate = self
        
        imageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(gesture)

        configViewComponents()
    }
    
    @objc
    private func didTapImage() {
        delegate?.didTapImage()
    }
    
    @objc
    private func switchAction2(sender: UISwitch) {
        if sender.isOn == false {
            dateLabel.text = ""
        } else {
            delegate?.switchActionL()
        }
    }
    
    @objc
    private func textColorSegmentControlTapped() {
        switch textColorSegmentControl.selectedSegmentIndex {
        case 0: textColorSegmentControl.selectedSegmentTintColor = .systemRed
        case 1: textColorSegmentControl.selectedSegmentTintColor = .label
        case 2: textColorSegmentControl.selectedSegmentTintColor = .systemYellow
        default: print("not")
        }
    }
    
    @objc
    private func deleteButtonAction() {
        self.imageView.image = UIImage(systemName: "photo.artframe")
        self.nameNoteTextView.text = "Enter note title..."
        self.descriptionTextView.text = "Enter note description..."
        
        self.textColorSegmentControl.selectedSegmentIndex = 1
        self.textColorSegmentControl.selectedSegmentTintColor = .label
        
        self.switchDate.isOn = false
        self.dateLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ChangeViewConstraints
extension ChangeView {
    private func configViewComponents() {
        
        addSubview(imageView)
        addSubview(nameNoteTextView)
        addSubview(descriptionTextView)
        
        addSubview(dateViewColor)
        
        dateViewColor.addSubview(makeUpLabel)
        dateViewColor.addSubview(switchDate)
        dateViewColor.addSubview(dateLabel)
        addSubview(colorLabel)
        addSubview(textColorSegmentControl)
        addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 7),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            nameNoteTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameNoteTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameNoteTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
            nameNoteTextView.heightAnchor.constraint(equalToConstant: 37),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionTextView.topAnchor.constraint(equalTo: nameNoteTextView.bottomAnchor, constant: 3),
            descriptionTextView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.14),
            
            dateViewColor.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30),
            dateViewColor.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            dateViewColor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateViewColor.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            makeUpLabel.topAnchor.constraint(equalTo: dateViewColor.safeAreaLayoutGuide.topAnchor),
            makeUpLabel.bottomAnchor.constraint(equalTo: dateViewColor.safeAreaLayoutGuide.bottomAnchor),
            makeUpLabel.leadingAnchor.constraint(equalTo: dateViewColor.leadingAnchor, constant: 10),
            makeUpLabel.widthAnchor.constraint(equalToConstant: 50),
            
            dateLabel.topAnchor.constraint(equalTo: dateViewColor.safeAreaLayoutGuide.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: dateViewColor.safeAreaLayoutGuide.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: makeUpLabel.trailingAnchor, constant: 10),
            dateLabel.widthAnchor.constraint(equalToConstant: 150),
            
            switchDate.trailingAnchor.constraint(equalTo: dateViewColor.trailingAnchor, constant: -7),
            switchDate.centerYAnchor.constraint(equalTo: dateViewColor.centerYAnchor),
            
            colorLabel.topAnchor.constraint(equalTo: dateViewColor.bottomAnchor, constant: 17),
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            colorLabel.widthAnchor.constraint(equalToConstant: 60),
            colorLabel.bottomAnchor.constraint(equalTo: textColorSegmentControl.bottomAnchor),
            
            textColorSegmentControl.topAnchor.constraint(equalTo: dateViewColor.bottomAnchor, constant: 17),
            textColorSegmentControl.leadingAnchor.constraint(equalTo: colorLabel.trailingAnchor, constant: 10),
            textColorSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -120),
            textColorSegmentControl.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.058),
            
            deleteButton.topAnchor.constraint(equalTo: colorLabel.topAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: textColorSegmentControl.trailingAnchor, constant: 15),
            deleteButton.bottomAnchor.constraint(equalTo: textColorSegmentControl.bottomAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17)
        ])
    }
}

// UITextView add invisible text
extension ChangeView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter note title..." || textView.text == "Enter note description..." {
            textView.text = ""
            textView.font = UIFont(name: "Times New Roman", size: 20)
            textView.textColor = UIColor.label
        }
    }
}
