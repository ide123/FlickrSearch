//
//  ViewModelContainerProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//
import Foundation

/// This means the conforming Class contains a ViewModel reference
protocol ViewModelContainerProtocol {
    associatedtype T
    var viewModel: T? { get set }
}

extension SearchViewController: ViewModelContainerProtocol {}
