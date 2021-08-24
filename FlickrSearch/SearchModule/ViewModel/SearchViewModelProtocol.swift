//
//  SearchableProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

/// Extend View Model protocol to add Search related features
protocol SearchViewModelProtocol: ViewModelProtocol {
    var  searchSpinnerViewBS: BehaviorSubject<Bool> { get }
    func search(for term: String)-> Observable<[ImageSearchResult]>
    func searchTermValidation(term: String) -> Bool
}
extension SearchViewModel: SearchViewModelProtocol { }
