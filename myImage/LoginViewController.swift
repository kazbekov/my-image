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
import GoogleSignIn
import TwitterKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    //MARK: -Properties
    let defaults = UserDefaults.standard
    var dict : NSDictionary!

    private lazy var facebookButton: UIButton = {
        return UIButton().then {
            $0.sizeToFit()
            $0.layer.cornerRadius = 3
            $0.backgroundColor = HexColor("3C5A96")
            $0.setTitleColor(.gray, for: .highlighted)
            $0.setTitle("  Войти через Facebook", for: .normal)
            $0.setImage(#imageLiteral(resourceName: "facebook-icon"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            $0.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        }
    }()
    
    private lazy var googleButton: UIButton = {
        return UIButton().then {
            $0.sizeToFit()
            $0.layer.cornerRadius = 3
            $0.backgroundColor = HexColor("DD4B39")
            $0.setTitleColor(.gray, for: .highlighted)
            $0.setImage(#imageLiteral(resourceName: "google-icon"), for: .normal)
            $0.setTitle("  Войти через Google", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            $0.addTarget(self, action: #selector(handleCustomGoogleSignIn), for: .touchUpInside)
        }
    }()
    
    private lazy var vkButton: UIButton = {
        return UIButton().then {
            $0.sizeToFit()
            $0.layer.cornerRadius = 3
            $0.backgroundColor = HexColor("5276A3")
            $0.setTitleColor(.gray, for: .highlighted)
            $0.setTitle("  Войти через Вконтакте", for: .normal)
            $0.setImage(#imageLiteral(resourceName: "vk-icon"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
//            $0.addTarget(self, action: #selector(logOutFunc), for: .touchUpInside)
        }
    }()
    
    private lazy var appIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = #imageLiteral(resourceName: "Icon-Input")
    }
    
    private lazy var submitButton: UIButton = {
        return UIButton().then {
            $0.sizeToFit()
            $0.backgroundColor = .clear
            $0.setTitle("Войти через почту", for: .normal)
            $0.setTitleColor(HexColor("684BE0"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            $0.addTarget(self, action: #selector(showSignup), for: .touchUpInside)
        }
    }()
    
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
        SVProgressHUD.setForegroundColor(HexColor("684BE0"))
        SVProgressHUD.setBackgroundColor(.white)
        view.backgroundColor = .white
        UIApplication.shared.statusBarStyle = .default
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        [facebookButton, googleButton, vkButton, appIconImageView, submitButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    func setUpConstraints() {
        
        constrain(appIconImageView, view){image, view in
            image.top == view.top + 130
            image.centerX == view.centerX
            image.width == view.width - 60
            image.height == 100
        }
        
        constrain(facebookButton, googleButton, vkButton, submitButton, view) { facebook, google, vk, submit, view in
            facebook.width == view.width * 0.7
            google.width == facebook.width
            vk.width == google.width
            
            facebook.height == 40
            google.height == facebook.height
            vk.height == google.height
            
            vk.bottom == submit.top
            
            facebook.centerX == view.centerX
            google.centerX == view.centerX
            vk.centerX == view.centerX
            
            distribute(by: 10, vertically: facebook, google, vk)
            
        }
        
        constrain(submitButton, view) {submit, view in
            submit.bottom == view.bottom * 0.87
            submit.width == view.width - 40
            submit.centerX == view.centerX
            submit.height == 44
        }
    }
    
    //MARK: - Actions
    
    func dismissView() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: User Interaction
    func showSignup(sender: UIButton) {
        self.submitButton.setTitleColor(.gray, for: .highlighted)
        if self.submitButton.isHighlighted {
            self.submitButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.submitButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
        present(SignUpViewController(), animated: true, completion: nil)
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func handleCustomGoogleSignIn(){
        SVProgressHUD.show()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func handleCustomFBLogin() {
        SVProgressHUD.show()
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self)
        { (result, err) in
            if err != nil{
                SVProgressHUD.dismiss()
                print("cannot", err ?? "")
                return
            }
            self.showEmailAddress()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        showEmailAddress()
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: {
            (user, error) in
            if error != nil{
                print("Sth went wrong with our FB user: ", error ?? "")
                return
            }
            self.defaults.set(true, forKey: "isLogged")
            print("Successfully logged in with our user: ", user ?? "")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            SVProgressHUD.showSuccess(withStatus: "Вы успешно \nавторизованы")
            SVProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
            
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fileds": "id, name, first_name, last_name, picture.type(large), email"]).start {
            (connection, result, err) in
            
            if err != nil{
                print("Failed to start graph request", err ?? "")
                return
            }
            
            self.dict = result as! NSDictionary
            self.defaults.set(self.dict.object(forKey: "name"), forKey: "name")
            self.defaults.set(self.dict.object(forKey: "id"), forKey: "id")
        }
    }
}

