//
//  CoreCoordinator.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import UIKit
import AVFoundation

//MARK: - Protocol
protocol CoordinatedViewControllerProtocol: UIViewController {
    var coreCoordinator: CoreCoordinator? { get set }
}

//MARK: - Class
open class CoreCoordinator: NavigationCoordinator {
    
    open var coordinated: UIViewController
    
    //MARK: - Object Lifecycle
    init(withCoordinated coordinated: UIViewController, parentCoordinator coordinator: Coordinator? = nil) {
        self.coordinated = coordinated
        super.init(withRootViewController: self.coordinated)
        self.parentCoordinator = coordinator
        (self.coordinated as? CoordinatedViewControllerProtocol)?.coreCoordinator = self
    }
    
    //MARK: - Transition Logic
    open func push(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        (viewController as? CoordinatedViewControllerProtocol)?.coreCoordinator = self
        (self.rootViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
        completion?()
    }
  
    func showDetailOf(withVolume volume: Volume) {}
}

