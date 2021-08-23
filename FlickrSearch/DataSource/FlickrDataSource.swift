//
//  FlickrDataSource.swift
//  FlickrSearch
//
//  Flickr Specific Data Source for Images
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

/// URL format for  Image load is
/// http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
/// Typical Response
/**"photos": {
 "page": 1,
 "pages": 1360,
 "perpage": 100,
 "total": 135956,
 "photo": [
 {
 "id": "51392247909",
 "owner": "61623396@N04",
 "secret": "4562dfac6b",
 "server": "65535",
 "farm": 66,
 "title": "Onion",
 "ispublic": 1,
 "isfriend": 0,
 "isfamily": 0
 },
 */
///
/// Flickr Access Key & Domain + Constants -
/// let ACCESS_KEY     = "96358825614a5d3b1a1c3fd87fca2b47"
let ACCESSKEY     = "92370f28e0d889c964a834a85d1790d3"
let DOMAIN         = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="
let DOMAINWITHKEY = DOMAIN + ACCESSKEY
let PARAMETERS     = "&format=json&nojsoncallback=1"

public class FlickrDataSource {

    /// Search for Images - uses DispatchGroup to synchronise the completion of the numerous API calls
    /// Uses escaping closure to return array of seach results
    func search(for term: String?, completion:@escaping ([ImageSearchResult]) -> Void) {

        var imageSearchResults    =  [ImageSearchResult]()
        var imageURLResults       =  [ImageURLResult]()
        let group                 =  DispatchGroup()

        /// Get the JSON meta data from the Search Term
        if let term = term {
            if let url = self.fullJsonURL(term) {
                group.enter()
                AF.request(url).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        /// Use Swifty JSON
                        let json = JSON(value)
                        /// Page 1 - all photos
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
                            print("URL: \(imageURLResult.url)")
                            return imageURLResult
                        }))!

                        group.leave()

                        /// Now get the Actual Images
                        imageSearchResults = imageURLResults.compactMap { imageURLResult -> ImageSearchResult? in
                            group.enter()
                            var imageSearchResult: ImageSearchResult?
                            AF.request(imageURLResult.url, method: .get).response { response in
                                switch response.result {

                                case .success(let responseData):
                                    let image = UIImage(data: responseData!, scale: 1)
                                    imageSearchResult = ImageSearchResult(title: imageURLResult.title, image: UIImageView(image: image))
                                    imageSearchResults.append(imageSearchResult!)
                                case .failure(let error):
                                    print("error--->", error)
                                }

                                group.leave()
                            }
                            return imageSearchResult
                        }
                        /// Sync. completion of all tasks - call completion with the Image data
                        group.notify(queue: DispatchQueue.global()) {
                            print("complete \(imageSearchResults.count)")
                            completion(imageSearchResults)
                        }

                    case .failure(let error):
                        print(error)
                    }
                }
                )}
        }
    }

    /// Get the Json URL (encoded) with added search term
    let fullJsonURL = { (term: String) -> String? in
        var preencoded =  DOMAINWITHKEY + "&text=" + term + PARAMETERS
        return  preencoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

}
