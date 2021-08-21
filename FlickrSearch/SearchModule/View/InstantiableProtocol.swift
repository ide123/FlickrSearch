//
//  InstantiableProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import UIKit

/// Protocol conformance implies the class can be loaded from a Nib file
/// and allows  Coordinator and ViewModel injection
protocol InstantiableProtocol {
    static func loadFromNib(with viewModel: ViewModelProtocol, coordinator:CoordinatorProtocol) -> Self
}

extension InstantiableProtocol where Self:UIViewController & ViewModelContainerProtocol & CoordinatedProtocol {

    static func loadFromNib(with viewModel: ViewModelProtocol, coordinator:CoordinatorProtocol) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        var vc = Self(nibName:className , bundle: nil)
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
 
}

extension SearchViewController : InstantiableProtocol{}
  

