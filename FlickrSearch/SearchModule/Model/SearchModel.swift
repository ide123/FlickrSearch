//
//  SearchModel.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

struct JSONSearchResult : Codable {
    ///
}

struct ImageSearchResult : Codable {
    ///
}

class SearchModel {
    
    var dataSource : DataSourceProtocol!
    
    /// Inject DataSource - this
    init(dataSource:DataSourceProtocol){
        self.dataSource = dataSource
    }
    ///
    func search(for term:String?) -> Observable<[ImageSearchResult]>{
        let results = dataSource.search(for:term){
        }
        return Observable.from([])
    }
}



