//
//  Coordinator.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import UIKit

//MARK: - Protocol
protocol Coordinator: class {
    var rootViewController: UIViewController { get }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator]? { get set }
}
