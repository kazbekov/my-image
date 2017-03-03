//
//  HomeViewController.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/2/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Cartography
import Sugar
import ChameleonFramework

class HomeViewController: UIViewController {
    
    //MARK: -Properties
    private lazy var filterButton: UIButton = {
        return UIButton().then{
            $0.setImage(Icon.filterIcon, for: .normal)
            $0.sizeToFit()
        }
    }()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    //MARK: -Setups
    func setUpViews(){
        setUpNavBar()
        UIApplication.shared.isStatusBarHidden = false
        view.backgroundColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    func setUpConstraints(){
        
    }
    func setUpNavBar(){
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Home"
        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
}
