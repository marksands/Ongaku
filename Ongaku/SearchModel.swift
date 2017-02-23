import Foundation
import RxSwift

public class SearchModel {
    private let service = MusicService()
    
    let titles: Observable<[String]>
    let songs: Observable<[Song]>
    let search: AnyObserver<String>
    
    private let _songs = BehaviorSubject<[Song]>(value: [])
    private let _search = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    public init() {
        songs = _songs.asObservable()
        search = _search.asObserver()
        titles = songs.map { $0.map { "\($0.artist) - \($0.name)" } }
        
        _search.flatMapLatest { [unowned self] in self.service.search($0) }.subscribe(_songs).addDisposableTo(disposeBag)
    }
}
