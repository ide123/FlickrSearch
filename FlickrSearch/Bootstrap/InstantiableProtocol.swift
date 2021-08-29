//
//  InstantiableProtocol.swift
//  FlickrSearch
//
//  Generic Load View Controller from Nib with Dependency Injection
//
//  Created by jonathan ide on 21/6/21.
//
import Foundation
import UIKit

/// Protocol conformance implies the class can be loaded from a Nib file
/// and allows  Coordinator and ViewModel injection
protocol InstantiableProtocol {

    static func loadFromNib<T: ViewModelProtocol, C: CoordinatorProtocol>(with viewModel: T, coordinator: C) -> Self
}
/// Extension to Custom View Controllers to allow Instantiation from Nib with DI.
extension InstantiableProtocol where Self: UIViewController & ViewModelContainerProtocol & CoordinatedProtocol {
 
    /// Generic Instantiate View Controller with DI - can inject any ViewModel or Controller Type providing they conform
    /// to ViewModel and Coordinator protocols respectively
    static func loadFromNib<T: ViewModelProtocol, C: CoordinatorProtocol>(with viewModel: T, coordinator: C) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        var viewController = Self(nibName: className, bundle: nil)
        viewController.viewModel = viewModel as? Self.T
        viewController.coordinator = coordinator
        return viewController
    }
}

extension SearchViewController: InstantiableProtocol {}
