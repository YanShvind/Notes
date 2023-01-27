
import UIKit

final class ChangeDataViewController: UIViewController {
    
    let index: Int
    var maneView = MainView()
    let noteManager = NoteManager()
    
    init(index: Int, maneView: MainView = MainView()) {
        self.index = index
        self.maneView = maneView
        super.init(nibName: nil, bundle: nil)
    }

    private let createView: ChangeView = {
        let view = ChangeView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Change"
        self.view.backgroundColor = .systemBackground
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        createView.delegate = self
        
        settingView()
        keyboardSetting()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change", style: .done, target: self, action: #selector(changeNoteAction))
    }
    
    override func loadView() {
        
        self.view = createView
    }
    
    private func settingView() {
        let imageStr = noteManager.getAllNotes()[index].photoImage
        let dataDecoded : Data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded) ?? UIImage(systemName: "photo.artframe")!
        
        self.createView.imageView.image = decodedimage
        self.createView.nameNoteTextView.text = noteManager.getAllNotes()[index].title
        self.createView.descriptionTextView.text = noteManager.getAllNotes()[index].description
        
        if noteManager.getAllNotes()[index].date != "" {
            self.createView.switchDate.isOn = true
            self.createView.dateLabel.text = noteManager.getAllNotes()[index].date
        }
    }
    
    private func keyboardSetting() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ChangeDataViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ChangeDataViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Create changeAction
extension ChangeDataViewController {
    @objc private func changeNoteAction() {
        if createView.nameNoteTextView.text == "" || createView.nameNoteTextView.text == "Enter note title..." {
            alertOk(title: "Error", messege: "Please enter correct Title")
        } else {
            print("Saved")
            alertOk(title: "Success", messege: nil)
            
            let newTitle = createView.nameNoteTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let date = createView.dateLabel.text!
            var newDescription = createView.descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if newDescription == "Enter note description..." {
                newDescription = ""
            }
            
            let imageL = createView.imageView.image
            let imageData: NSData = imageL!.pngData()! as NSData
            var strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            if imageL ==  UIImage(systemName: "photo.artframe") {
                strBase64 = ""
            }
            
            let textColor = createView.textColorSegmentControl.selectedSegmentIndex
            let noteReady = noteManager.getAllNotes()[index].noteReady
            let note = NoteModel(title: newTitle, description: newDescription, date: date, noteReady: noteReady, segmentContrId: textColor, photoImage: strBase64)
            
            maneView.noteManager.setComplete(note: note, index: index)
        }
    }
}

extension ChangeDataViewController: ChangeViewSwProtocol {
    func didTapImage() {
        presentPhotoActionSheet()
    }
    
    func switchActionL() {
        alertDate(label: createView.dateLabel, switchL: createView.switchDate)
    }
}

extension ChangeDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Note Picture",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        createView.imageView.image = selectedImage
     }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ChangeDataViewController {
    @objc
    private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height / 1.7
                self.title = ""
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height / 1.7
                self.title = "Create a note"
            }
        }
    }
}
