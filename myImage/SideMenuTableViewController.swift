//
//  SideMenuTableViewController.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/25/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import SideMenuController
import ChameleonFramework
import Foundation
import Cartography
import UIKit
import MessageUI
//import Kingfisher
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import SVProgressHUD

class SideMenuTableViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let sideMenuCellIdentifier = "sideMenuCellIdentifier"
    let profileSideMenuCellIdentifier = "profileSideMenuCellIdentifier"
    let loggedProfileSideMenuCellIdentifier = "loggedProfileSideMenuCellIdentifier"
    let aboutMeMenuCellIdentifier = "aboutMeMenuCellIdentifier"
    let titles = ["Вход/Регистрация", "Главная","Уведомления","Настройки","Выйти"]
    let icons = [#imageLiteral(resourceName: "profile-icon-1"),#imageLiteral(resourceName: "home-icon-1"),#imageLiteral(resourceName: "ring-icon"),#imageLiteral(resourceName: "settings-icon-1"), #imageLiteral(resourceName: "logout-icon")]
    lazy var tableView: UITableView = {
        return UITableView().then {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.separatorColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 100
            $0.bounces = false
            $0.tableFooterView = UIView()
            $0.register(SideMenuTableViewCell.self, forCellReuseIdentifier: self.sideMenuCellIdentifier)
            $0.register(ProfileSideMenuTableViewCell.self, forCellReuseIdentifier: self.profileSideMenuCellIdentifier)
            $0.register(LoggedProfileTableViewCell.self, forCellReuseIdentifier: self.loggedProfileSideMenuCellIdentifier)
        }
    }()
    
    lazy var backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "bg-rose")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    //MARK: - Setups
    
    func setUpViews() {
        SVProgressHUD.setForegroundColor(HexColor("684BE0"))
        SVProgressHUD.setBackgroundColor(.white)
        [backgroundImageView, tableView].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    func setUpConstraints() {
        constrain(tableView, backgroundImageView, view) {table, bg, view in
            table.edges == view.edges
            
            bg.width == view.width
            bg.height == 225
        }
    }
    
    //MARK: -ReloadData
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    //MARK: -Actions
    
    func logOutFunc(){
        SVProgressHUD.show()
        
        if self.defaults.bool(forKey: "isLoggedFB"){
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.defaults.set(false, forKey: "isLoggedFB")
            SVProgressHUD.dismiss(withDelay: 1.5, completion: {
                let firebaseAuth = FIRAuth.auth()
                do {
                    try firebaseAuth?.signOut()
                    self.tableView.reloadData()
                }catch let signOutError as NSError {
                    print("Error with signOutFacebook \(signOutError)")
                }
                SVProgressHUD.showSuccess(withStatus: "Вы успешно \nвышли")
            })
            
        } else if self.defaults.bool(forKey: "isLoggedGID"){
            GIDSignIn.sharedInstance().signOut()
            self.defaults.set(false, forKey: "isLoggedGID")
            SVProgressHUD.dismiss(withDelay: 1.5, completion: {
                let firebaseAuth = FIRAuth.auth()
                do {
                    try firebaseAuth?.signOut()
                    self.tableView.reloadData()
                }catch let signOutError as NSError {
                    print("Error with signOutGoogle \(signOutError)")
                }
                SVProgressHUD.showSuccess(withStatus: "Вы успешно \nвышли")
            })
        } else if self.defaults.bool(forKey: "isLoggedCustom"){
            self.defaults.set(false, forKey: "isLoggedCustom")
            SVProgressHUD.dismiss(withDelay: 1.5, completion: {
                let firebaseAuth = FIRAuth.auth()
                do {
                    try firebaseAuth?.signOut()
                    self.tableView.reloadData()
                }catch let signOutError as NSError {
                    print("Error with signOutGoogle \(signOutError)")
                }
                SVProgressHUD.showSuccess(withStatus: "Вы успешно \nвышли")
            })
        }
    }
}

// MARK: UITableViewDelegate
extension SideMenuTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            present(LoginViewController(), animated: true, completion: nil)
        case 1:
            sideMenuController?.embed(centerViewController: UINavigationController(rootViewController: HomeViewController()))
        case 2:
            sideMenuController?.embed(centerViewController: UINavigationController(rootViewController:
                NotificationsViewController()))
        case 3:
            sideMenuController?.embed(centerViewController: UINavigationController(rootViewController: SettingsTableViewController()))
        case 4:
            logOutFunc()
        default:
            return
        }
    }
}

// MARK: UITableViewDataSource
extension SideMenuTableViewController: UITableViewDataSource , MFMailComposeViewControllerDelegate{
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.defaults.bool(forKey: "isLoggedFB") || self.defaults.bool(forKey: "isLoggedGID") || self.defaults.bool(forKey: "isLoggedCustom") {
            return titles.count
        } else{
            return titles.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 250
        default: return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && self.defaults.bool(forKey: "isLoggedFB") {
            return(tableView.dequeueReusableCell(withIdentifier: self.loggedProfileSideMenuCellIdentifier, for: indexPath as IndexPath) as! LoggedProfileTableViewCell).then {
                let userID = self.defaults.object(forKey: "id")
                if let fbId = userID {
                    $0.setupAvaWithProperties(urlString: "http://graph.facebook.com/\(fbId)/picture?type=large", name: "\(self.defaults.object(forKey: "name") ?? "")", email: "\(self.defaults.object(forKey: "email") ?? "")")
                }
                $0.isUserInteractionEnabled = false
                $0.contentView.backgroundColor = .clear
                $0.backgroundColor = .clear
                $0.selectionStyle = .none
            }
        } else if indexPath.row == 0 && self.defaults.bool(forKey: "isLoggedGID"){
            return(tableView.dequeueReusableCell(withIdentifier: self.loggedProfileSideMenuCellIdentifier, for: indexPath as IndexPath) as! LoggedProfileTableViewCell).then {
                if let photoURL = self.defaults.object(forKey: "photoURLGID") {
                    $0.setupAvaWithProperties(urlString: "\(photoURL)", name: "\(self.defaults.object(forKey: "nameGID") ?? "")", email: "\(self.defaults.object(forKey: "emailGID") ?? "")")
                }
                $0.isUserInteractionEnabled = false
                $0.contentView.backgroundColor = .clear
                $0.backgroundColor = .clear
                $0.selectionStyle = .none
            }
        } else if indexPath.row == 0 && self.defaults.bool(forKey: "isLoggedCustom"){
            return(tableView.dequeueReusableCell(withIdentifier: self.loggedProfileSideMenuCellIdentifier, for: indexPath as IndexPath) as! LoggedProfileTableViewCell).then {
                $0.setupAvaWithProperties(urlString: "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png", name: "", email: "\(self.defaults.object(forKey: "customEmail") ?? "")")
                $0.isUserInteractionEnabled = false
                $0.contentView.backgroundColor = .clear
                $0.backgroundColor = .clear
                $0.selectionStyle = .none
            }
        }
        else {
                return(tableView.dequeueReusableCell(withIdentifier: self.sideMenuCellIdentifier, for: indexPath as IndexPath) as! SideMenuTableViewCell).then {
                    $0.setupWithProperties(icon: self.icons[indexPath.row], title: self.titles[indexPath.row])
                    $0.setDownSubtitle()
                    $0.contentView.backgroundColor = .clear
                    $0.backgroundColor = .clear
                    $0.selectionStyle = .none
            }
        }
    }
}
