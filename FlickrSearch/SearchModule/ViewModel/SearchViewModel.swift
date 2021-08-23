//
//  SearchViewModel.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

class SearchViewModel : NSObject{
    
    var model         : ModelProtocol!
    var spinnerViewBS : BehaviorSubject<Bool> = BehaviorSubject(value: true)
    var disposeBag    = DisposeBag()
    
    /// Initialise with Model
    init(model:ModelProtocol) {
        self.model = model
        model.loadingStatus.map { status -> Bool in
            return true
        }.bind(to: spinnerViewBS.asObserver()).disposed(by: disposeBag)
    }
    /// Main Search - input term - output optional SearchResults
    func search(for term: String) -> Observable<[ImageSearchResult]> {
        let obs =  model.search(for: term)
        return obs
    }
    /// Crude Check Size of Term
    func validate(term:String)->Bool{
        if term.count > 0 {
            return true
        }else{
            return false
        }
    }
    
    deinit{
        print("deinit \(self)")
    }
}
