//
//  CoordinatedProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/6/21.
//

import Foundation

/// View Controllers are Coordinated - and have  a ref to a coordinator
protocol CoordinatedProtocol {
    var coordinator: CoordinatorProtocol? { get set }
}

extension SearchViewController: CoordinatedProtocol {}
