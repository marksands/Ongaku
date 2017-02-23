import AVFoundation
import UIKit
import RxSwift
import RxSugar

class PlayerViewController : UIViewController {
    private let player: AVPlayer
    
    init(song: Song) {
        player = AVPlayer(url: song.previewURL)
        super.init(nibName: nil, bundle: nil)
        
        title = "\(song.artist) - \(song.name)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let playerView = PlayerView()
        self.view = playerView
        
        PlayerBinding.bind(view: playerView, player: player)
    }
}

struct PlayerBinding {
    static func bind(view: PlayerView, player: AVPlayer) {
        view.rxs.disposeBag
            ++ view.progress <~ player.rxs.playingProgress
            ++ player.rxs.play <~ view.play
            ++ player.rxs.pause <~ view.pause
    }
}
