
import UIKit

extension UIView {
    convenience init(color: UIColor){
        self.init()
        
        self.backgroundColor = color
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
