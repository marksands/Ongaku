import UIKit

extension CGSize {
    func centered(in rect: CGRect) -> CGRect {
        return CGRect(x: rect.midX - width / 2.0, y: rect.midY - height / 2.0, width: width, height: height)
    }
    
    func alignedRight(_ rect: CGRect) -> CGRect {
        return CGRect(x: rect.maxX - width, y: rect.midY - height / 2.0, width: width, height: height)
    }
}
