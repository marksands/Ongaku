import UIKit

class PaddedTextField : UITextField {
    private let horizontalMargin: CGFloat = 8
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalMargin, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalMargin, dy: 0)
    }
}
