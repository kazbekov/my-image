//
//  DetailHomeViewController.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/28/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import MessageUI
import Cartography
import ChameleonFramework

class DetailHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    //MARK: -Properties
    lazy var contacts = [String]()
    var status: String?
    var route: String?
    var image: UIImage?
    lazy var icons = [#imageLiteral(resourceName: "website"),#imageLiteral(resourceName: "envelope-2"),#imageLiteral(resourceName: "cell")]
    var infoDict: [String:String]?{
        didSet{
            guard let email = infoDict?["emails"] else { return }
            guard let phone = infoDict?["phone"] else { return }
            guard let websites = infoDict?["websites"] else { return }
            
            contacts = ["\(websites)", "\(email)", "\(phone)"]
            if websites == ""{
                contacts[0] = "нет данных"
            }
            if email == ""{
                contacts[1] = "нет данных"
            }
            if phone == ""{
                contacts[2] = "нет данных"
            }
        }
    }
    
    private let tableHeaderHeight: CGFloat = 300
    lazy var labelEmpty = UILabel()
    private lazy var headerView: DetailCollectionHeaderView = {
        
        return DetailCollectionHeaderView(frame: CGRect(x: 0, y: 0,
                                                    width: UIScreen.main.bounds.width, height: self.tableHeaderHeight)).then {
                                                        _ in
//                                                        $0.delegate = self
        }
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = self.headerView
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(MapDetailTableViewCell.self, forCellReuseIdentifier: "MapCell")
        tableView.register(ContactsDetailTableViewCell.self, forCellReuseIdentifier: "ContactsCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = HexColor("F5F5F5")
        return tableView
    }()
    
    lazy var gradientView = UIView()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        setUpHeaderView()
        gradientView.backgroundColor = GradientColor(.topToBottom, frame: gradientView.bounds, colors: [HexColor("2C2C2C")!,.clear])
        headerView.profileBackroundImageView.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
        // get previous view controller and set title to "" or any things You want
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil; // get previous view
            previousVC?.title = "" // or previousVC?.title = "Back"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = HexColor("DA3C65")
    }
    //MARK: -Setups
    
    func setUpViews() {
        self.automaticallyAdjustsScrollViewInsets = false
//        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        setUpNavBar()
        
        [labelEmpty, tableView, gradientView].forEach{
            view.addSubview($0)
        }
    }
    func setUpNavBar(){
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
//        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func setUpConstraints() {
        constrain(tableView, view, gradientView){ tableView, view, gradientView in
            tableView.edges == view.edges
            gradientView.width == view.width
            gradientView.centerX == view.centerX
            gradientView.top == view.top
            gradientView.height == 64
        }
    }
    private func setUpHeaderView() {
        guard let frame = tableView.tableHeaderView?.frame else { return }
        headerView.frame = frame
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight,
                                width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
        view.layoutIfNeeded()
    }

    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                UIApplication.shared.openURL(URL(string: "http://www.tattoo-status.kz")!)
            case 1:
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            case 2:
                callNumber(phoneNumber: "98989")
            default:
                return
            }
        default:
            return
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    //Add Notification
    func addNot(){
        let addNotificationVC = AddNotificationsViewController()
        addNotificationVC.message = (infoDict?["name"])!
        self.navigationController?.pushViewController(addNotificationVC, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            tableView.separatorStyle = .singleLine
            return 3
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath) as! DetailTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = infoDict?["name"]
            cell.stateLabel.text = self.status
            cell.infoLabel.text = infoDict?["info"]
            cell.isUserInteractionEnabled = true
            cell.addNotificationButton.addTarget(self, action: #selector(addNot), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath as IndexPath) as! MapDetailTableViewCell
            cell.selectionStyle = .none
            cell.addressLabel.text = infoDict?["address"]
            cell.setUpViews(lat: Double((infoDict?["lat"])!)!, long: Double((infoDict?["longt"])!)!, title: (infoDict?["name"])!, subtitle: "\(contacts[2])")
            cell.routeLabel.text = route
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath as IndexPath) as! ContactsDetailTableViewCell
                cell.setUpWithProperties(title: contacts[indexPath.row], icon: icons[indexPath.row])
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath) as! DetailTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = HexColor("F5F5F5")
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return -20
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

// MARK: UIScrollViewDelegate

extension DetailHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
}
