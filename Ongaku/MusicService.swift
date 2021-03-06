import Foundation
import RxSwift
import RxSugar

public struct Song: Equatable {
    public let artist: String
    public let name: String
    public let previewURL: URL
    
    public init(artist: String, name: String, previewURL: URL) {
        self.artist = artist
        self.name = name
        self.previewURL = previewURL
    }
    
    static public func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.artist == rhs.artist && lhs.name == rhs.name && lhs.previewURL == rhs.previewURL
    }
}

public struct MusicService {
    public func search(_ value: String) -> Observable<[Song]> {
        return Observable<Data?>
            .create { observer in
                let sanitizedValue = value.replacingOccurrences(of: " ", with: "+")
                guard   
                    let url = URL(string: "http://itunes.apple.com/search?term=\(sanitizedValue)&entity=song")
                    else { observer.onNext(nil); return Disposables.create() }
                
                let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                    observer.onNext(data)
                    observer.onCompleted()
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
            .ignoreNil()
            .map(MusicService.mapSongData)
            .observeOn(MainScheduler.instance)
    }
    
    static func mapSongData(_ data: Data) -> [Song] {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any],
            let results = json?["results"] as? [[String:Any]]
            else {
                return []
        }
        
        let defaultUrl = "http://a1007.phobos.apple.com/us/r30/Music/38/07/e9/mzm.xnbpcddz.aac.p.m4a"
        
        return results
            .map { ($0["artistName"] as? String ?? "", $0["trackName"] as? String ?? "", URL(string: $0["previewUrl"] as? String ?? defaultUrl)!) }
            .map(Song.init)
    }
}
