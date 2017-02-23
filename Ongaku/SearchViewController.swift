import UIKit
import RxSwift
import RxSugar

class SearchViewController: UIViewController {
    private let model = SearchModel()
    private var presenter: SearchPresenter?
    
    override func loadView() {
        let searchView = SearchView()
        self.view = searchView
        
        title = "おんがく"
        
        presenter = SearchPresenter(view: searchView, model: model, launchSong: { [weak self] song in
            self?.navigationController?.pushViewController(PlayerViewController(song: song), animated: true)
        })
    }
}

final class SearchPresenter: SearchViewProtocol {
    private let view: SearchView
    private let model: SearchModel
    private let launchSong: (Song)->()
    
    init(view: SearchView, model: SearchModel, launchSong: @escaping (Song)->()) {
        self.view = view
        self.model = model
        self.launchSong = launchSong
        view.delegate = self
    }
    
    func textChanged(_ text: String) {
        model.search(text).onSuccess { [unowned self] songTitles in
            self.view.data = songTitles
        }
    }
    
    func indexSelected(_ index: Int) {
        launchSong(model.songs[index])
    }
}
