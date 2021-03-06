//
//  SearchableProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/6/21.
//

import Foundation
import RxSwift

/// Extend View Model protocol to add Search related features
protocol SearchViewModelProtocol: ViewModelProtocol {
    var  searchSpinnerViewBS: BehaviorSubject<Bool> { get }
    func search(for term: String, page: Int)-> Observable<[ImageSearchResult]>
    func searchTermValidation(term: String) -> Bool
}
/// Here we conform the ViewModel to the Search "Feature" and that its a ViewModel by type
extension SearchViewModel: SearchViewModelProtocol { }
