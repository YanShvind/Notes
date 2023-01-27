
import UIKit

final class PopUpDescription: UIView {
    
    var index: Int = 0
    var noteManager = NoteManager()
    var customTableViewCell = CustomTableViewCell()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.text = ""
        textView.textAlignment = .justified
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        self.backgroundColor = UIColor.systemGray.withAlphaComponent(0.6)
        self.frame = UIScreen.main.bounds
        
        configViewComponents()
        animateIn()
    }
    
    @objc
    private func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) {(complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc
    private func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        }) {(complete) in
            let textL = self.noteManager.getAllNotes()[self.index].description
            let strBase64 = self.noteManager.getAllNotes()[self.index].photoImage
            let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
            let decodedimage:UIImage = UIImage(data: dataDecoded) ?? UIImage(systemName: "photo.artframe")!
            self.imageView.image = decodedimage
            self.descriptionTextView.text = textL
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PopUpDescriptionConstraints
extension PopUpDescription {
    private func configViewComponents() {
        
        addSubview(container)
        container.addSubview(descriptionLabel)
        container.addSubview(imageView)
        container.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            
            descriptionLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 25),
            
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 7),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.45),
            
            descriptionTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            descriptionTextView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30)
        ])
    }
}
