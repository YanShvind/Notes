
import UIKit

extension UIViewController {
    func alertOkL(title: String, messege: String?) {
        
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(okAction)
                
        present(alert, animated: true)
    }
}
