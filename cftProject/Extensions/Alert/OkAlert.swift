
import UIKit

extension UIViewController {
    func alertOk(title: String, messege: String?) {
        
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }

        alert.addAction(okAction)
                
        present(alert, animated: true)
    }
}
