//
//  SearchModel.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

/// Image URL  Result
struct ImageURLResult {
    ///Variables for URL
    var id     : String
    var farm   : Int
    var secret : String
    var server : String
    var title  : String?
    /// Return the URL composed from the properties
    var url : String {
        get {
            let start =  "http://farm" + String(farm) + ".static.flickr.com/"
            let end   =  server + "/" + id + "_" + secret + ".jpg"
            return start + end
        }
    }
    
}

/// Returned from Search
struct ImageSearchResult {
    ///Variables for URL
    var title  : String?
    var image  : UIImage?
}

class SearchModel {
    
    var dataSource : DataSourceProtocol!
    
    /// Inject DataSource - this
    init(dataSource:DataSourceProtocol){
        self.dataSource = dataSource
    }
    ///
    func search(for term:String?) -> Observable<[ImageSearchResult]>{
        
        return Observable<[ImageSearchResult]>.create { [weak self] observer in
            self?.dataSource.search(for: term) { imageResults in
                print("Model: \(imageResults.count)")
                observer.onNext(imageResults)
            }
            return Disposables.create()
        }
  
    }
}



