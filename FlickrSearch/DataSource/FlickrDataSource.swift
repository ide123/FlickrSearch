//
//  FlickrDataSource.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

/// Flickr Access Key & Domain + Constants
let ACCESS_KEY = "96358825614a5d3b1a1c3fd87fca2b47"
let PRE_DOMAIN    = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="
let PRE_DOMAIN_KEY = PRE_DOMAIN + ACCESS_KEY
let POST_DOMAIN = "&format=json&nojsoncallback=1"
/// URL for Image
///http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg

public class FlickrDataSource {
    
    /// Load the full URL
    let fullURL = { (word:String) -> String? in
        return PRE_DOMAIN_KEY + "&text=" + word + POST_DOMAIN
    }
    
    /// Search for Images
    func search(for term:String?, completion:@escaping () -> Void){
        print("FDS Search \(term)")
            if let term = term {
                if let url = self.fullURL(term) {
                    print("URL: \(url)")
                    AF.request(url).responseJSON(completionHandler: { response in
                        switch response.result {
                        case .success(let value):
                            if let json = value as? [String: Any] {
                                print("JSON: \(json)")
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
            }
        }
    }
    
    
    /// Search for Images
    /**func search(for term:String?)-> Observable<[ImageSearchResult]> {
        print("FDS Search \(term)")
        return Observable<[ImageSearchResult]>.create { [weak self] observer in
            print(" Term \(term)")
            if let term = term {
                if let url = self?.fullURL(term) {
                    print("URL: \(url)")
                    AF.request(url).responseJSON(completionHandler: { response in
                        switch response.result {
                        case .success(let value):
                            if let json = value as? [String: Any] {
                                print("JSON: \(json)")
                            }
                            observer.onNext([])
                        case .failure(let error):
                            print(error)
                            observer.onNext([])
                        }
                    })
                }
            }
            return Disposables.create()
        }
    }*/

