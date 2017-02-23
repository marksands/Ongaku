import UIKit

protocol PlayerViewProtocol: class {
    func play()
    func pause()
}

class PlayerView : UIView, PlayPauseViewProtocol {
    private let blueColor = UIColor(hue:0.64, saturation:0.90, brightness:0.96, alpha:1.00)
    private let circleLayer = CAShapeLayer()
    private let lineWidth: CGFloat = 6
    
    private let playPauseView = PlayPauseView()
    
    weak var delegate: PlayerViewProtocol?
    
    var progress: CGFloat = 0 {
        didSet {
            circleLayer.strokeEnd = progress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        circleLayer.backgroundColor = UIColor.white.cgColor
        circleLayer.borderColor = blueColor.cgColor
        circleLayer.borderWidth = lineWidth
        circleLayer.strokeColor = blueColor.cgColor
        circleLayer.lineWidth = lineWidth * 2
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0
        circleLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(circleLayer)
        
        playPauseView.delegate = self
        addSubview(playPauseView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        delegate?.play()
    }
    
    func pause() {
        delegate?.pause()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circleSize: CGFloat = bounds.width * 0.75
        let cornerRadius = circleSize / 2
        
        let contentSize: CGFloat = circleSize / 4
        
        circleLayer.frame = CGSize(width: circleSize, height: circleSize).centered(in: bounds)
        circleLayer.cornerRadius = cornerRadius
        circleLayer.path = UIBezierPath(roundedRect: circleLayer.bounds.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius: cornerRadius).cgPath
        
        playPauseView.frame = CGSize(width: contentSize, height: contentSize).centered(in: bounds)
    }
}
