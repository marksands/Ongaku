import AVFoundation

public class MusicPlayer : NSObject {
    private let player: AVPlayer
    private var timeObserverToken: Any?

    private var progressHandler: (CGFloat)->() = { _ in }
    
    init(url: URL) {
        player = AVPlayer(url: url)

        super.init()
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.01, Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] time in
            if let timeRange = self?.player.currentItem?.loadedTimeRanges.first?.timeRangeValue {
                self?.progressHandler(max(min(CGFloat(time.seconds / timeRange.duration.seconds), 1), 0))
            }
        })
    }
    
    func play(progressHandler: @escaping (CGFloat)->()) {
        self.progressHandler = progressHandler
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    deinit {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
        }
    }
}
