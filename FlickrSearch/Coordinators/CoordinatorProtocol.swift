//
//  CoordinatorProtocol.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import UIKit

/// Implementors are Coordinators
/// implementors must be classes not structs because they need to be shared
/// - inheritance from AnyObject forces this.
protocol CoordinatorProtocol  : AnyObject {
    var  childCoordinators    : [CoordinatorProtocol] { get set }
    var  navigationController : UINavigationController { get set }
    func start()

}
