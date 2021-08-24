//
//  Util.swift
//  FlickrSearch
//
//  Created by jonathan ide on 24/8/21.
//

import Foundation
import UIKit

public class Util {
    
    /// Generic Configure Function
    public static func configure<T>(_ value: T, using closure: (inout T) throws -> Void
    ) rethrows -> T {
        var value = value
        try closure(&value)
        return value
    }
    
    /// Generic Alert
    public static func presentOptions(currentViewController: UIViewController, title: String, option1: String, action1: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            let controller = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
            
            let action = UIAlertAction(title: option1, style: .default) { (_) in
                // We do something!
                action1()
            }
            
            controller.addAction(action)
            
            /// Default - Cancel
            
            let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                controller.dismiss(animated: true, completion: nil)
            }
            
            controller.addAction(action2)
            
            /// IPad Support
            
            if let presenter = controller.popoverPresentationController {
                presenter.sourceView = currentViewController.view
                presenter.sourceRect = CGRect(x: presenter.sourceView!.bounds.midX, y: presenter.sourceView!.bounds.midY, width: 0, height: 0)
   
            }
                    
            currentViewController.present(controller, animated: true) {}
        }
    }
}
