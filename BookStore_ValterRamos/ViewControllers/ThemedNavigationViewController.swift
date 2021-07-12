//
//  ThemedNavigationViewController.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import UIKit

//MARK: - Class
open class ThemedNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    //MARK: - Object Lifecycle
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.commonInit()
    }
    
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.delegate = self
    }

    //MARK: - Display Logic
    #if os(iOS)
    override open var preferredStatusBarStyle: UIStatusBarStyle {
      return (self.viewControllers.last?.preferredStatusBarStyle)!
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .portrait
    }
    #endif
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        let barTintColor: UIColor? = UIColor.blue
        let headerTintColor: UIColor? = UIColor.white
        let textColor: UIColor? = UIColor.black
        
        self.tabBarController?.tabBar.barTintColor = barTintColor
        self.navigationBar.barTintColor = headerTintColor
        
        if viewController.navigationItem.titleView == nil {
            let view = UIView(frame: .zero)
            let label = UILabel(frame: .zero)
            label.textColor = textColor
            label.text = viewController.title
            label.sizeToFit()
            view.addSubview(label)
            view.frame = label.frame
            
            viewController.navigationItem.titleView = view
        }
    }
}
