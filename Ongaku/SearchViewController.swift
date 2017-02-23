import UIKit
import RxSwift
import RxSugar

class SearchViewController: UIViewController {
    private let model = SearchModel()

    override func loadView() {
        let searchView = SearchView()
        self.view = searchView
        
        title = "おんがく"
        
        SearchBinding.bind(view: searchView, model: model, launchSong: { [weak self] song in
            self?.navigationController?.pushViewController(PlayerViewController(song: song), animated: true)
        })
    }
}

struct SearchBinding {
    static func bind(view: SearchView, model: SearchModel, launchSong: @escaping (Song)->()) {
        view.rxs.disposeBag
            ++ model.search <~ view.textEvents
            ++ view.data <~ model.titles
            ++ launchSong <~ view.selectionEvents.withLatestFrom(model.songs) { $1[$0] }
    }
}
