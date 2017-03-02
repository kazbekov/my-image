//
//  LoginViewController.swift
//  myImage
//
//  Created by Damir Kazbekov on 3/2/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    //MARK: -Properties
    let loginButton = FBSDKLoginButton()
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    //MARK: - Setups
    
    func setUpViews() {
        SVProgressHUD.setForegroundColor(.red)//684BE0
        SVProgressHUD.setBackgroundColor(.white)
        view.backgroundColor = .white
        UIApplication.shared.statusBarStyle = .default
        [loginButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    func setUpConstraints() {
        constrain(loginButton, view) { facebook, view in
            facebook.width == view.width * 0.7
            facebook.height == 40
            facebook.centerX == view.centerX
        }
    }
}

