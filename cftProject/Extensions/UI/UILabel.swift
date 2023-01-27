
import UIKit

extension UILabel {
    convenience init(text: String){
        self.init()
        
        self.text = text
        self.font = UIFont(name: "San Francisco", size: 24)
        self.textColor = .label
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
