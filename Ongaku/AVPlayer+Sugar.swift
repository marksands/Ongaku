import AVFoundation
import RxSwift
import RxSugar

extension Sugar where HostType : AVPlayer {
    var play: AnyObserver<Void> {
        return valueSetter { (host, _) in host.play() }
    }
    
    var pause: AnyObserver<Void> {
        return valueSetter { (host, _) in host.pause() }
    }
        
    var playingProgress: Observable<CGFloat> {
        return Observable.create { [weak host] observer in
            guard let this = host else { return Disposables.create() }
            
            let token = this.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.01, Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { time in
                if let timeRange = this.currentItem?.loadedTimeRanges.first?.timeRangeValue {
                    observer.onNext(CGFloat(time.seconds / timeRange.duration.seconds))
                }
            })
            
            return Disposables.create {
                this.removeTimeObserver(token)
            }
        }
    }
}
