
import UIKit

final class AddNewCellViewController: UIViewController {
    
    var maneView = MainView()
    
    private let createView: AddNewCellView = {
        let view = AddNewCellView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create a note"
        self.view.backgroundColor = .systemBackground
        
        createView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        keyboardSetting()
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNoteAction))
    }
    
    override func loadView() {
        
        self.view = createView
    }
    
    private func keyboardSetting() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(AddNewCellViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(AddNewCellViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: Create saveAction
extension AddNewCellViewController {
    @objc private func saveNoteAction() {
        if createView.nameNoteTextView.text == "" || createView.nameNoteTextView.text == "Enter note title..."
        {
            alertOkL(title: "Error", messege: "Please enter correct Title")
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
            let note = NoteModel(title: newTitle, description: newDescription, date: date, noteReady: false, segmentContrId: textColor, photoImage: strBase64)
            
            maneView.noteManager.create(note: note)
        }
    }
}

//MARK: AddNewCellViewOutputProtocol
extension AddNewCellViewController: AddNewCellViewOutputProtocol {
    func didTapImage() {
        presentPhotoActionSheet()
    }
    
    func switchAction() {
        alertDate(label: createView.dateLabel, switchL: createView.switchDate)
    }
}

extension AddNewCellViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Note Picture",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    private func presentPhotoPicker() {
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

extension AddNewCellViewController {
    @objc
    private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height / 2
                self.title = ""
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height / 2
                self.title = "Create a note"
            }
        }
    }
}
