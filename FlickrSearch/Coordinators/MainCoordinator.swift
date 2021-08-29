//
//  MainCoordinator.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/6/21.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, CoordinatorProtocol, UINavigationControllerDelegate {
    ///
    var childCoordinators    =  [CoordinatorProtocol]()
    var navigationController: UINavigationController
    var window: UIWindow

    ///
    init(window: UIWindow) {
        self.window                    = window
        self.navigationController      = UINavigationController()
        self.window.rootViewController = navigationController
    }

    /// Need to push the VC on to the Nav. Controller - this is the bootstrap VC
    ///
    /// - Parameters:
    /// - Throws:
    /// - Returns:
    func start() {
        /// Make this the Nav Delegate
        self.navigationController.delegate = self
        /// Bootstrap and DI.
        /// The FlickrDataSource exposes an API to make the Seach.
        /// The SearchViewModel is initialised with a SearchModel. The View Controller is instantiated from a Nib
        /// and initialised with the SearchViewModel  and  a Coordinator . This sets up the dependencies correctly and
        /// makes it easy to test the View Controller with a Mock ViewModel / Mock Model
        let dataSource  = FlickrDataSource()
        let searchModel = SearchModel(dataSource: dataSource)
        let searchViewModel = SearchViewModel(model: searchModel)
        let vc = SearchViewController.loadFromNib(with: searchViewModel, coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }

    /// Nav. delegate Method - this can be  used to manage child coordinators
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

           /// Read the view controller we’re moving from.
           guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
               return
           }

           print("Did Show: \(viewController) from: \(fromViewController)")

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

    }

    /// Not used unless we use child coordinators
    /**func childDidFinish(_ child: CoordinatorProtocol?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                print("Remove: \(coordinator)")
                childCoordinators.remove(at: index)
                break
            }
        }
    }*/

}
