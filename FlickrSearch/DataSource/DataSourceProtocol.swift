//
//  DataSourceProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/6/21.
//

import Foundation
import RxSwift

protocol DataSourceProtocol {
    func search(for term: String?, page: Int, completion:@escaping ([ImageSearchResult]) -> Void)
}

extension FlickrDataSource: DataSourceProtocol { }
