//
//  MainTabBarController.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/2/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import ChameleonFramework

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            UINavigationController(rootViewController: HomeViewController()),
            UINavigationController(rootViewController: ProfileViewController())
        ]
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.tintColor = HexColor("DA3C65")
        tabBar.unselectedItemTintColor = HexColor("C3BCBE")
        
        setUpTabBarItem(tabBarItem: tabBar.items?[0],
                        image: #imageLiteral(resourceName: "home-icon"),
                        selectedImage: #imageLiteral(resourceName: "home-selected-icon"))
        setUpTabBarItem(tabBarItem: tabBar.items?[1], 
                        image: Icon.profileIcon ,
                        selectedImage: Icon.profileSelectedIcon)
    }
    
    
    // MARK: Set Up
    
    private func setUpTabBarItem(tabBarItem: UITabBarItem?, image: UIImage?,
                                 selectedImage: UIImage?) {
        
        tabBarItem?.image = image
        tabBarItem?.selectedImage = selectedImage
        tabBarItem?.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    }
}
