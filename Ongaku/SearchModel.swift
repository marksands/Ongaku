import Foundation
import BrightFutures
import Result

class SearchModel {
    private let service = MusicService()
    
    var songs: [Song] = []
    
    func search(_ value: String) -> Future<[String], NoError> {
        let future = service.search(value)
        
        future.onSuccess(callback: { [unowned self] songs in
            self.songs = songs
        })

        return future.map { $0.map { "\($0.artist) - \($0.name)" } }
    }
}
