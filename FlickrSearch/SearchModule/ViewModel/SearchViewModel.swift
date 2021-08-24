//
//  SearchViewModel.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
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
    func search(for term: String) -> Observable<[ImageSearchResult]> {
        return model.search(for: term)
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
