import UIKit
import RxSwift

class PlayerView : UIView {
    private let blueColor = UIColor(hue:0.64, saturation:0.90, brightness:0.96, alpha:1.00)
    private let circleLayer = CAShapeLayer()
    private let lineWidth: CGFloat = 6
    
    private let playPauseView = PlayPauseView()
    
    let play: Observable<Void>
    let pause: Observable<Void>
    let progress: AnyObserver<CGFloat>
    
    private let _progress = PublishSubject<CGFloat>()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        progress = _progress.asObserver()
        play = playPauseView.play
        pause = playPauseView.pause
        
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
        
        addSubview(playPauseView)
        
        _progress.subscribe(onNext: { [weak self] progress in
            self?.circleLayer.strokeEnd = max(min(1, progress), 0)
        }).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
