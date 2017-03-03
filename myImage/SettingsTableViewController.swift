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

class SettingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: -Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 70)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = HexColor("#D1D5DB")
        return tableView
    }()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    //MARK: -Setups
    
    func setUpViews() {
        [tableView].forEach{
            view.addSubview($0)
        }
        title="Настройки"
        navigationController?.navigationBar.tintColor = .white
    }
    func setUpConstraints() {
        constrain(tableView, view){ tableView, view in
            tableView.edges == view.edges
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5//SettingsSection.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath) as! SettingsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
