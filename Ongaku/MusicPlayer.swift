import AVFoundation
import RxSwift

public class MusicPlayer {
    private let player: AVPlayer
    private var token: Any?
    
    let progress: Observable<CGFloat>
    let play: AnyObserver<Void>
    let pause: AnyObserver<Void>
    
    private let _progress = BehaviorSubject<CGFloat>(value: 0)
    private let _play = PublishSubject<Void>()
    private let _pause = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    init(url: URL) {
        player = AVPlayer(url: url)
        progress = _progress.asObservable()
        play = _play.asObserver()
        pause = _pause.asObserver()
        
        _play.subscribe(onNext: { [weak self] in
            self?.player.play()
        }).addDisposableTo(disposeBag)
        
        _pause.subscribe(onNext: { [weak self] in
            self?.player.pause()
        }).addDisposableTo(disposeBag)
        
        token = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.01, Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] time in
            if let timeRange = self?.player.currentItem?.loadedTimeRanges.first?.timeRangeValue {
                self?._progress.onNext(CGFloat(time.seconds / timeRange.duration.seconds))
            }
        })
    }
    
    deinit {
        if let token = token {
            player.removeTimeObserver(token)
        }
    }
}
