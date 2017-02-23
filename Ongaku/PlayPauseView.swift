import UIKit
import RxSwift

class PlayPauseView : UIView {
    private let triangle = CAShapeLayer()
    private let leftBar = UIView()
    private let rightBar = UIView()
    private let blueColor = UIColor(hue:0.64, saturation:0.90, brightness:0.96, alpha:1.00)
    private let touchArea = UIButton()
    
    let play: Observable<Void>
    let pause: Observable<Void>
    private let _play = PublishSubject<Void>()
    private let _pause = PublishSubject<Void>()
    
    private let tapEvents = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        play = _play.asObservable()
        pause = _pause.asObservable()
        
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
        
        let tap = tapEvents.map { [weak self] in !(self?.triangle.isHidden ?? false) }.share()
        
        tap.filter { $0 }.map { _ in }.subscribe(_play).addDisposableTo(disposeBag)
        tap.filter { !$0 }.map { _ in }.subscribe(_pause).addDisposableTo(disposeBag)
        
        Observable.of(_play.map { false }, _pause.map { true }).merge().subscribe(onNext: { [weak self] show in
            self?.showPlay(show)
        }).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped() {
        tapEvents.onNext(())
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
    
    private func showPlay(_ show: Bool) {
        if show {
            triangle.isHidden = false
            leftBar.isHidden = true
            rightBar.isHidden = true
        } else {
            leftBar.isHidden = false
            rightBar.isHidden = false
            triangle.isHidden = true
        }
    }
}
