//
//  NavigatorCoordinator.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import UIKit

//MARK: - Class
open class NavigationCoordinator: Coordinator {
    
    //MARK: - Variables
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]?
    
    open var rootViewController: UIViewController {
        return navigationController
    }
    open var navigationController: ThemedNavigationController
    
    //MARK: - Object Lifecycle
    public init(withRootViewController rootViewController: UIViewController) {
        self.navigationController = ThemedNavigationController(rootViewController: rootViewController)
        self.navigationController.navigationBar.isTranslucent = false
    }
}
