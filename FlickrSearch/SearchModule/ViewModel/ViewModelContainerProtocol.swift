//
//  ViewModelContainerProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/6/21.
//
import Foundation

/// This means the conforming Class contains a generic ViewModel reference
/// In this case its the SearchViewController that contains the VM
protocol ViewModelContainerProtocol {
    associatedtype T
    var viewModel: T? { get set }
}

extension SearchViewController: ViewModelContainerProtocol {}
