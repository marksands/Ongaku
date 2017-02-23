import Foundation

protocol SearchModelProtocol: class {
    func searchResultsFound(_ titles: [String])
}

class SearchModel {
    private let service = MusicService()
    
    weak var delegate: SearchModelProtocol?
    
    var songs: [Song] = [] {
        didSet {
            delegate?.searchResultsFound(songs.map { "\($0.artist) - \($0.name)" })
        }
    }
    
    func search(_ value: String) {
        service.search(value, completion: { [weak self] songs in
            self?.songs = songs
        })
    }
}
