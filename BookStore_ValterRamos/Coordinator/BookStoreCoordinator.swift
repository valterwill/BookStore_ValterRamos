//
//  BookStoreCoordinator.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import UIKit
import Foundation

//MARK: - Class
class BookStoreCoordinator: CoreCoordinator {
    
    //MARK: - Object Lifecycle
    init() {
      let viewModel = BookStoreViewModel()
      let viewController = BookStoreViewController(viewModel: viewModel)
      super.init(withCoordinated: viewController)
    }
    
    override func showDetailOf(withVolume volume: Volume) {
        let bookDetailViewModel = BookDetailViewModel()
        bookDetailViewModel.volume = volume
        let bookDetailViewController = BookDetailViewController(viewModel: bookDetailViewModel)
        self.push(bookDetailViewController)

    }
    
    //MARK: - Transition Logic
    override func push(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        (viewController as? CoordinatedViewControllerProtocol)?.coreCoordinator = self
        (self.rootViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
        completion?()
    }
}
