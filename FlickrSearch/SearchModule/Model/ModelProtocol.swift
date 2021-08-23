//
//  ModelProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

/// This is a marker for a  Generic ViewModel Type
protocol ModelProtocol {
    var  loadingStatus : PublishSubject<LOADING_STATUS> { get set }
    func search(for term:String?) -> Observable<[ImageSearchResult]>
}

extension SearchModel : ModelProtocol{}
