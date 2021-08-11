import Foundation

#if os(Linux)
import FoundationNetworking
#endif

// MARK: - FlickrAPI
struct FlickrAPI {
    static let baseURLString = "https://api.flickr.com/services/rest"
    
    // keys and tokens - ideally from plist
    static let apiKey = ""

    func search(tag: String, completion: @escaping (Result<Photos,Error>) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URLParams = [
            "method": EndPoint.searchPhotos.rawValue,
            "api_key": FlickrAPI.apiKey,
            "format": "json",
            "nojsoncallback": "1",
            "tags": tag
        ]
        var queryItems:[URLQueryItem] = []
        for (key,value) in URLParams {
            queryItems.append(URLQueryItem(name:key, value: value))
        }
        var urlComps = URLComponents(string: FlickrAPI.baseURLString)!
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        var request = URLRequest(url: result)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                if let s = String(data:data!,encoding: .utf8) {
                }
                do {
                    let photos = try JSONDecoder().decode(Photos.self, from: data!)
                    completion(.success(photos))
                }
                catch {
                    let e = FlickrError.parsing(description: error.localizedDescription)
                    print(e)
                    completion(.failure(e))
                }
            }
            else {
                if let e = error {
                    let flickrError = FlickrError.network(description: e.localizedDescription)
                    print(flickrError)
                    completion(.failure(flickrError))
                }
            }
        })
        task.resume()
    }
}

// MARK: - EndPoint
enum EndPoint: String {
    case searchPhotos = "flickr.photos.search"
}

// MARK: - FlickrError
enum FlickrError: Error {
  case parsing(description: String)
  case network(description: String)
}

// MARK: - Photos
struct Photos: Codable {
    let photos: PhotosClass
    let stat: String
}

// MARK: - PhotosClass
struct PhotosClass: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

extension Photo: Identifiable { }

struct MockFlickrAPI {
    func search(tag: String, completion: @escaping (Result<Photos,Error>) -> Void) {
        let ps = Photos(photos: PhotosClass(page: 1, pages: 1, perpage: 1, total: 1, photo: []), stat: "0")
        completion(.success(ps))
    }
}
