import UIKit

protocol PlayPauseViewProtocol: class {
    func play()
    func pause()
}

class PlayPauseView : UIView {
    private let triangle = CAShapeLayer()
    private let leftBar = UIView()
    private let rightBar = UIView()
    private let blueColor = UIColor(hue:0.64, saturation:0.90, brightness:0.96, alpha:1.00)
    private let touchArea = UIButton()
    
    weak var delegate: PlayPauseViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftBar.backgroundColor = blueColor
        rightBar.backgroundColor = blueColor
        
        leftBar.isHidden = true
        rightBar.isHidden = true
        
        layer.addSublayer(triangle)
        addSubview(leftBar)
        addSubview(rightBar)
        
        touchArea.addTarget(self, action: #selector(PlayPauseView.tapped), for: .touchUpInside)
        addSubview(touchArea)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped() {
        let isPlaying = triangle.isHidden
        
        if isPlaying {
            delegate?.pause()
            triangle.isHidden = false
            leftBar.isHidden = true
            rightBar.isHidden = true
        } else {
            delegate?.play()
            leftBar.isHidden = false
            rightBar.isHidden = false
            triangle.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.close()
        triangle.fillColor = blueColor.cgColor
        triangle.path = path.cgPath
        
        let (leftBarFrame, remainingArea) = bounds.divided(atDistance: 0.35 * bounds.width, from: .minXEdge)
        let rightBarFrame = remainingArea.divided(atDistance: leftBarFrame.width, from: .maxXEdge).slice
        
        leftBar.frame = leftBarFrame
        rightBar.frame = rightBarFrame
        
        touchArea.frame = bounds
    }
}
