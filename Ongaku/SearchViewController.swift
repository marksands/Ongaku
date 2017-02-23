import UIKit

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

final class SearchPresenter: SearchViewProtocol, SearchModelProtocol {
    private let view: SearchView
    private let model: SearchModel
    private let launchSong: (Song)->()
    
    init(view: SearchView, model: SearchModel, launchSong: @escaping (Song)->()) {
        self.view = view
        self.model = model
        self.launchSong = launchSong
        view.delegate = self
        model.delegate = self
    }
    
    func searchResultsFound(_ titles: [String]) {
        view.data = titles
    }
    
    func textChanged(_ text: String) {
        model.search(text)
    }
    
    func indexSelected(_ index: Int) {
        launchSong(model.songs[index])
    }
}
