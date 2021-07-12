//
//  SceneDelegate.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var rootCoordinator: CoreCoordinator?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else {
        return
    }
    self.rootCoordinator = BookStoreCoordinator()
    self.window = UIWindow(windowScene: windowScene)
    self.window?.rootViewController = self.rootCoordinator!.rootViewController
    self.window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {}
  func sceneDidBecomeActive(_ scene: UIScene) {}
  func sceneWillResignActive(_ scene: UIScene) {}
  func sceneWillEnterForeground(_ scene: UIScene) {}
  func sceneDidEnterBackground(_ scene: UIScene) {}

}

