//
//  SearchableProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

protocol SearchableProtocol: ViewModelProtocol {
    var  spinnerViewBS: BehaviorSubject<Bool> { get set }
    func search(for term: String)-> Observable<[ImageSearchResult]>
    func validate(term: String) -> Bool
}
