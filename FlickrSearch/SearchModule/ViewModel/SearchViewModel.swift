//
//  SearchViewModel.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

class SearchViewModel : NSObject{
    
    var model : ModelProtocol!
    
    /// Initialise with Model
    init(model:ModelProtocol) {
        self.model = model
    }
    /// Main Search - input term - output optional SearchResults
    func search(for term: String) -> Observable<[ImageSearchResult]> {
        return model.search(for: term)
    }
    
    deinit{
        print("deinit \(self)")
    }
}
