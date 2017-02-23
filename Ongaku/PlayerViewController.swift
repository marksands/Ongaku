import UIKit

class PlayerViewController : UIViewController {
    private let player: MusicPlayer
    private var presenter: PlayerPresenter?
    
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
        
        presenter = PlayerPresenter(view: playerView, player: player)
    }
}

final class PlayerPresenter : PlayerViewProtocol {
    private let view: PlayerView
    private let player: MusicPlayer
    
    init(view: PlayerView, player: MusicPlayer) {
        self.view = view
        self.player = player
        view.delegate = self
    }
    
    func play() {
        player.play { [weak self] progress in
            self?.view.progress = progress
        }
    }
    
    func pause() {
        player.pause()
    }
}
