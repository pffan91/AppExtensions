import Foundation
import UIKit

// swiftlint:disable:next all
extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { layer.borderColor.map(UIColor.init(cgColor:)) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get { layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get { CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { layer.shadowColor.map(UIColor.init(cgColor:)) }
        set { layer.shadowColor = newValue?.cgColor }
    }
}

@IBDesignable
class DesignableView: UIView {
    
    @IBInspectable var computeCornerRadius: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.computeCornerRadius {
            self.cornerRadius = min(self.frame.width, self.frame.height) / 2
        }
    }
}
