import UIKit
import RxSwift

class SearchViewController: UIViewController {
    private let model = SearchModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        let searchView = SearchView()
        self.view = searchView
        
        title = "おんがく"
        
        searchView.textEvents.subscribe(model.search).addDisposableTo(disposeBag)
        model.titles.subscribe(searchView.data).addDisposableTo(disposeBag)
        
        searchView.selectionEvents.withLatestFrom(model.songs) { $1[$0] }.subscribe(onNext: { [weak self] song in
            self?.navigationController?.pushViewController(PlayerViewController(song: song), animated: true)
        }).addDisposableTo(disposeBag)
    }
}
