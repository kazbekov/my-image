//
//  SettingsTableViewController.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/3/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework
import TTGEmojiRate
import MessageUI

class SettingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: -Properties
    var counter = 0
    var counterRate = 0
    let ratingTexts = ["Очень плохо", "Плохо", "Нормально", "Хорошо", "Очень хорошо", "Отлично"]
    
    
    let titles = ["Поделиться", "Оценить", "Написать нам"]
    let icons = [#imageLiteral(resourceName: "share"), #imageLiteral(resourceName: "star"), #imageLiteral(resourceName: "contact")]
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 70)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var shareView: UIView = {
        return UIView().then {
            $0.backgroundColor = HexColor("DA3C65")
            $0.alpha = 0
        }
    }()
    
    private lazy var ratingView: UIView = {
        return UIView().then {
            $0.backgroundColor = .black
            $0.alpha = 0
        }
    }()
    
    private lazy var dimView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "Поделиться с друзьями"
        $0.font = UIFont.boldSystemFont(ofSize: 17.0)
        $0.textColor = .white
    }
    
    private lazy var facebookButton: UIButton = {
        return UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "facebook-share-icon"), for: .normal)
            $0.tag = 0
            $0.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        }
    }()
    
    private lazy var twitterButton: UIButton = {
        return UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "twitter-share-icon"), for: .normal)
            $0.tag = 1
            $0.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        }
    }()
    
    private lazy var instagramButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "instagram-share-icon"), for: .normal)
        $0.tag = 2
    }
    
    private lazy var cancelButton: UIButton = {
        return UIButton().then {
            $0.setTitle("Отмена", for: .normal)
            $0.addTarget(self, action: #selector(dismissShareView), for: .touchUpInside)
        }
    }()
    
    private lazy var cancelButtonRating: UIButton = {
        return UIButton().then {
            $0.setTitle("Отменв", for: .normal)
            $0.addTarget(self, action: #selector(dismissRatingView), for: .touchUpInside)
        }
    }()
    
    private lazy var ratingLabel: UILabel = {
        return UILabel().then {
            $0.text = "5.0/2.5"
            $0.font = .systemFont(ofSize: 25, weight: 0.7)
        }
    }()
    
    private lazy var rateView: EmojiRateView = {
        return EmojiRateView().then {
            $0.frame = CGRect(x:0, y: 0, width: 200, height: 200)
            $0.center = self.view.center
            $0.backgroundColor = .black
            $0.rateValueChangeCallback = {(rateValue: Float) -> Void in
                self.ratingLabel.text = String(
                    format: "%.2f / 5.0, %@",
                    rateValue, self.ratingTexts[Int(rateValue)])
                self.shareView.alpha = 0
                self.counter = 0
            }
        }
    }()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        ratingLabel.textColor = .white
    }
    
    //MARK: -Setups
    
    func setUpViews() {
        [tableView, dimView, shareView, ratingView].forEach{
            view.addSubview($0)
        }
        [titleLabel, facebookButton, twitterButton, instagramButton, cancelButton].forEach {
            shareView.addSubview($0)
        }
        [rateView, cancelButtonRating, ratingLabel].forEach{
            ratingView.addSubview($0)
        }
        title="Настройки"
        setUpNavBar()
    }
    func setUpNavBar(){
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Настройки"
        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.isTranslucent = false
    }

    func setUpConstraints() {
        constrain(tableView, view){ tableView, view in
            tableView.edges == view.edges
        }
        constrain(shareView, dimView, view) {shareView, dimView, view in
            shareView.bottom == view.bottom
            shareView.leading == view.leading
            shareView.trailing == view.trailing
            shareView.height == view.height / 2.6
            
            
            dimView.edges == view.edges
        }
        
        constrain(ratingView, cancelButtonRating, ratingLabel, view) {ratingView, cancelButtonRating, ratingLabel, view in
            ratingView.edges == view.edges
            
            ratingLabel.centerX == view.centerX
            ratingLabel.top == view.top + 70
            
            cancelButtonRating.bottom == ratingView.bottom - 5
            cancelButtonRating.centerX == ratingView.centerX
        }
        
        constrain(shareView, titleLabel, facebookButton ,cancelButton) {shareView, titleLabel, facebookButton, cancelButton in
            titleLabel.top == shareView.top + 15
            titleLabel.centerX == shareView.centerX
            
            facebookButton.top == titleLabel.bottom + 20
            
            cancelButton.bottom == shareView.bottom - 5
            cancelButton.centerX == shareView.centerX
        }
        
        constrain(shareView, twitterButton, facebookButton, instagramButton) {shareView, twitterButton, facebookButton, instagramButton in
            
            align(top: facebookButton, twitterButton, instagramButton)
            distribute(by: 57, horizontally: facebookButton, twitterButton, instagramButton)
            
            facebookButton.width == 60
            facebookButton.height == 60
            
            twitterButton.centerX == shareView.centerX
            twitterButton.width == 60
            twitterButton.height == 60
            
            instagramButton.width == 60
            instagramButton.height == 60
            
        }
        
    
    }
    
    func shareButtonPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            ShareController.shareFacebookPost(vc: self)
        case 1:
            ShareController.shareTwitterPost(vc: self)
        case 2:
            return
        default:
            return
        }
    }
    
    func dismissShareView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.dimView.alpha = 0
            self.shareView.frame.origin.y += self.shareView.frame.size.height
        }, completion: nil)
    }
    
    func dismissRatingView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.ratingView.frame.origin.y += self.ratingView.frame.size.height
        }, completion: nil)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            if counter != 1 {
                self.shareView.frame.origin.y += self.shareView.frame.size.height
                counter = 1
            }
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dimView.alpha = 0.7
                self.shareView.alpha = 1
                self.shareView.frame.origin.y -= self.shareView.frame.size.height
            }, completion: nil)
        case (0,1):
            if counterRate != 1 {
                self.ratingView.frame.origin.y += self.ratingView.frame.size.height
                counterRate = 1
            }
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.ratingView.alpha = 0.7
                self.ratingView.frame.origin.y -= self.ratingView.frame.size.height
            }, completion: nil)
            
        case (0,2):
            let mailComposeViewCotroller = configureMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewCotroller, animated: true, completion: nil)
            }else{
                self.showSendMailErrorAlert()
            }
        default:
            return
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5//SettingsSection.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath) as! SettingsTableViewCell
        cell.setUpCellWithProperties(title: titles[indexPath.row], icon: icons[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
   // func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case SettingsSection.Plan.rawValue: return SectionHeaderView(title: "ПЛАН")
//        case SettingsSection.Mode.rawValue: return SectionHeaderView(title: "СМЕНА РЕЖИМА")
//        case SettingsSection.Notificaions.rawValue: return SectionHeaderView(title: "УВЕДОМЛЕНИЯ")
//        case SettingsSection.Account.rawValue: return SectionHeaderView(title: "АККАУНТ")
//        default: return SectionHeaderView()
//        }
    //}
}

extension SettingsTableViewController

: MFMailComposeViewControllerDelegate{
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["bekenovanel@gmail.com"])
        mailComposerVC.setSubject("Предложение по улучшению")
        mailComposerVC.setMessageBody("Привет, разработчики!\n\n Я бы хотел(а) предложить... \n", isHTML: false)
        return mailComposerVC
    }
    func showSendMailErrorAlert(){
        let alertCntrl = UIAlertController(title: "Не удалось отправить е-mail", message: "Ваше устроиство не смогло отправить е-mail. Пожалуйста проверьте настройки e-mail и повторите попытку.", preferredStyle: .alert)
        alertCntrl.addAction(UIAlertAction(title: "Хорошо", style: .cancel) { _ in })
        self.present(alertCntrl, animated: true){}
    }
}
