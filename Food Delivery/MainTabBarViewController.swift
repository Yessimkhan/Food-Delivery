//
//  ViewController.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 22.06.2023.
//

import UIKit

class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UINavigationController(rootViewController: MenuViewController())
        let vc2 = UINavigationController(rootViewController: ContactsViewController())
        let vc3 = UINavigationController(rootViewController: ProfileViewController())
        let vc4 = UINavigationController(rootViewController: BasketViewController())
        
        vc1.tabBarItem.image = UIImage(named: "Menu")
        vc2.tabBarItem.image = UIImage(named: "Contacts")
        vc3.tabBarItem.image = UIImage(named: "Profile")
        vc4.tabBarItem.image = UIImage(named: "Basket")
        vc1.title = "Menu"
        vc2.title = "Contacts"
        vc3.title = "Profile"
        vc4.title = "Basket"
        tabBar.tintColor = Colors.tintColor
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        self.viewControllers?.forEach({
            $0.tabBarItem.setTitleTextAttributes([.font: UIFont(name: "SFUIDisplay-Medium", size: 13)], for: .normal)
        })
    }
    
    
}

