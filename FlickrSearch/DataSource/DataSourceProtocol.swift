//
//  DataSourceProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

protocol DataSourceProtocol {
    func search(for term:String?,completion:@escaping () -> Void)
}

extension FlickrDataSource : DataSourceProtocol{}

