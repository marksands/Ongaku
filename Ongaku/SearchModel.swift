import Foundation
import RxSwift
import RxSugar

public class SearchModel : RXSObject {
    private let service = MusicService()
    
    let titles: Observable<[String]>
    let songs: Observable<[Song]>
    let search: AnyObserver<String>
    
    private let _songs = Variable<[Song]>([])
    private let _search = PublishSubject<String>()
    
    public init() {
        songs = _songs.asObservable()
        search = _search.asObserver()
        
        titles = songs.map { $0.map { "\($0.artist) - \($0.name)" } }
        
        rxs.disposeBag
            ++ _songs <~ _search.flatMapLatest { [unowned self] in self.service.search($0) }
    }
}
