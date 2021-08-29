//
//  SceneDelegate.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/6/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // Use this method to configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // Scenes allow multi-window based apps - this delegate is for all scenes in the App.
        if let windowScene = scene as? UIWindowScene {
            /// Create Window from Scene
            let window     = UIWindow(windowScene: windowScene)
            ///  Create RootVC - a Nav Controller. Set it as a reference on the Coordinator
            ///  The coodinator uses a stack to manage the VCs
            let coordinator = MainCoordinator(window: window)
            /// Let coodrinator bootstrap the rootVC
            coordinator.start()
            /// This line is critical - must set top level window to locally created one from the scene - if not done the screen is blank.
            /// Also remove the Main storyboard from the Info pList otherwise it loads from the Storyboard specified - Main.
            self.window = window
            /// Make the window show
            window.makeKeyAndVisible()
        }

    }

}
