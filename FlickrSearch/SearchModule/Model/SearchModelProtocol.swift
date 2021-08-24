//
//  ModelProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

/// This is a marker for a  Generic ViewModel Type
protocol SearchModelProtocol: ModelProtocol {
    var  loadingStatus: PublishSubject<LOADINGSTATUS> { get set }
    func search(for term: String?, page: Int) -> Observable<[ImageSearchResult]>
}

extension SearchModel: SearchModelProtocol {}
