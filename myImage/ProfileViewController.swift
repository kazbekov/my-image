//
//  ProfileViewController.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/2/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Cartography
import Sugar
import ChameleonFramework

class ProfileViewController: UIViewController {
    //MARK: -Properties
    private lazy var settingsButton: UIButton = {
        return UIButton().then{
            $0.setImage(Icon.settingsIcon, for: .normal)
            $0.sizeToFit()
            $0.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
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
        navigationController?.navigationBar.topItem?.title = "Profile"
        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    //MARK: -Actions
    func showSettings(){
        navigationController?.pushViewController(SettingsTableViewController(), animated: true)
    }
}
