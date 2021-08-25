//
//  FlickrDataSource.swift
//  FlickrSearch
//
//  Self-Contained Flickr Specific Data Source for Images
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

/// Image URL  Result
struct ImageURLResult {
    /// Variables for URL
    var id: String
    var farm: Int
    var secret: String
    var server: String
    var title: String?
    /// Return the URL composed from the properties
    var url: String {
        get {
            let start =  "http://farm" + String(farm) + ".static.flickr.com/"
            let end   =  server + "/" + id + "_" + secret + ".jpg"
            return start + end
        }
    }
}

/// Returned from Search
struct ImageSearchResult {
    /// Variables for URL
    var title: String?
    var image: UIImageView?
}

/// Basic Status -can be expanded as required.
enum LOADINGSTATUS {
    case LOADINGCOMPLETE
}

/// URL format for  Image load is
/// http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
/// Flickr Access Key & Domain + Constants -
/// let ACCESS_KEY     = "96358825614a5d3b1a1c3fd87fca2b47"
private let ACCESSKEY     = "92370f28e0d889c964a834a85d1790d3"
private let DOMAIN        = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="
private let DOMAINWITHKEY = DOMAIN + ACCESSKEY
private let PARAMETERS    = "&format=json&nojsoncallback=1&page="

public class FlickrDataSource {

    /// Search for Images - uses DispatchGroup to synchronise the completion of the numerous API calls
    /// Uses escaping closure to return array of seach results. Defaults to page 1 if not set.
    func search(for term: String?, page: Int=1, completion:@escaping ([ImageSearchResult]) -> Void) {

        var imageSearchResults    =  [ImageSearchResult]()
        var imageURLResults       =  [ImageURLResult]()
        let group                 =  DispatchGroup()
        
        guard let term = term else {
            completion(imageSearchResults)
            return
        }
        
        guard !term.isEmpty else {
            completion(imageSearchResults)
            return
        }
        
        /// Get the JSON meta data from the Search Term
        if let url = self.fullJsonURL(term, page) {
            group.enter()
            AF.request(url).responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    /// Use Swifty JSON
                    let json = JSON(value)
                    /// Page N - all photos
                    imageURLResults = (json["photos"]["photo"].array?.compactMap({ photo ->  ImageURLResult? in
                        /// Get Image Title - can be Nil
                        let title  = photo["title"].string
                        /// Extract URL variable Values from Json
                        guard let photoID = photo["id"].string,
                              let farm    = photo["farm"].int,
                              let secret  = photo["secret"].string,
                              let server  = photo["server"].string else {
                            return nil
                        }
                        /// Create a URL result
                        let imageURLResult = ImageURLResult(id: photoID, farm: farm, secret: secret, server: server, title: title)
                        return imageURLResult
                    }))!
                    
                    group.leave()
                    
                    /// Now get the Actual Images
                    _ =  imageURLResults.compactMap { imageURLResult -> ImageSearchResult? in
                        group.enter()
                        var imageSearchResult: ImageSearchResult?
                        AF.request(imageURLResult.url, method: .get).response { response in
                            switch response.result {
                            case .success(let responseData):
                                if let responseData = responseData {
                                    if let image = UIImage(data: responseData, scale: 1) {
                                        imageSearchResult = ImageSearchResult(title: imageURLResult.title, image: UIImageView(image: image))
                                        imageSearchResults.append(imageSearchResult!)
                                    }
                                }
                            case .failure(let error):
                                print("error", error)
                            }
                            
                            group.leave()
                        }
                        return imageSearchResult
                    }
                    /// Sync. completion of all tasks - call completion with the Image data
                    group.notify(queue: DispatchQueue.global()) {
                        print("Complete \(imageSearchResults.count)")
                        completion(imageSearchResults)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            )}
        
    }

    /// Get the Json URL (encoded) with added search term and page number
    let fullJsonURL = { (term: String, page: Int) -> String? in
        
       var preencoded =  DOMAINWITHKEY + "&text=" + term
       var parameters =  PARAMETERS + String(page)
      
        guard  let preamble = preencoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let param =  parameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        return preamble + param
        
    }

}
