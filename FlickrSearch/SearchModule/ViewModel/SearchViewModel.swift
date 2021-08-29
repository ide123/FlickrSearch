//
//  SearchViewModel.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/6/21.
//

import Foundation
import RxSwift

class SearchViewModel: NSObject {

    var model: SearchModelProtocol!
    var disposeBag = DisposeBag()
    var searchSpinnerViewBS: BehaviorSubject<Bool> = BehaviorSubject(value: true)

    /// Initialise with Model
    init(model: SearchModelProtocol) {
        super.init()
        self.model = model
        model.loadingStatus.map { _ -> Bool in
            return true
        }.bind(to: searchSpinnerViewBS.asObserver()).disposed(by: disposeBag)
    }
    /// Main Search - input term - output optional SearchResults
    ///
    /// - Parameters: term : Seach Term , page: Page number
    /// - Throws:
    /// - Returns: Observable event containing Array of Image Search Results
    func search(for term: String, page: Int) -> Observable<[ImageSearchResult]> {
        return model.search(for: term, page: page)
    }
    /// Crude Check Size of Term
    func searchTermValidation(term: String) -> Bool {
        if !term.isEmpty {
            return true
        } else {
            return false
        }
    }

}
