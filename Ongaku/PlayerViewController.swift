import UIKit
import RxSwift

class PlayerViewController : UIViewController {
    private let player: MusicPlayer

    private let disposeBag = DisposeBag()
    
    init(song: Song) {
        player = MusicPlayer(url: song.previewURL)
        super.init(nibName: nil, bundle: nil)
        
        title = "\(song.artist) - \(song.name)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let playerView = PlayerView()
        self.view = playerView

        player.progress.subscribe(playerView.progress).addDisposableTo(disposeBag)
        playerView.play.subscribe(player.play).addDisposableTo(disposeBag)
        playerView.pause.subscribe(player.pause).addDisposableTo(disposeBag)
    }
}
