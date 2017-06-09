//
//  LoggedProfileTableViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/27/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework
import Kingfisher

final class LoggedProfileTableViewCell: UITableViewCell {
    
    fileprivate var constraintGroup: ConstraintGroup?
    
    lazy var avatarImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "ava")
        $0.layer.cornerRadius = 47.5
        
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 25)
        $0.text = "Анель Бекенова"
    }
    
    lazy var emailLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15)
        $0.text = "anelbekenova@gmail.com"
    }
    
//    lazy var dateLabel = UILabel().then {
//        $0.textAlignment = .left
//        $0.textColor = .white
//        $0.font = .systemFont(ofSize: 15)
//        $0.text = "01.02.95"
//    }
    
    lazy var emailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "envelope")
    }
    
//    lazy var calendarImageView = UIImageView().then {
//        $0.contentMode = .scaleAspectFill
//        $0.clipsToBounds = true
//        $0.image = #imageLiteral(resourceName: "calendar")
//    }
    
    lazy var shadowView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = HexColor("363636")?.cgColor
        $0.layer.shadowRadius = 15.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.5
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = false
        $0.layer.cornerRadius = 30.5
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        [shadowView, avatarImageView, titleLabel, emailLabel, emailImageView].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(avatarImageView, titleLabel, emailLabel, contentView, emailImageView) { icon, label, emailLabel, view, emailImageView in
            icon.width == 95
            icon.height == 95
            icon.leading == view.leading + 20
            icon.top == view.top + 20
            
            label.leading == view.leading + 20
            label.top == icon.bottom + 10
        }
        
        constrain(titleLabel, emailImageView, emailLabel) {
            $1.leading == $0.leading
            $1.top == $0.bottom + 10
            
            $2.leading == $1.trailing + 5
            $2.top == $1.top
            
        }
        constrain(shadowView, avatarImageView) {
            $0.center == $1.center
            $0.width == $1.width - 10
            $0.height == $1.height - 10
        }
    }
}

extension LoggedProfileTableViewCell {
    func setupWithProperties(icon: UIImage?, title: String?) {
        avatarImageView.image = icon
        titleLabel.text = title
    }
    
    func setUpSubtitle() {
        emailLabel.alpha = 0.6
        if let constraintGroup = constraintGroup { constrain(clear: constraintGroup) }
        constraintGroup = constrain(avatarImageView, titleLabel, emailLabel,contentView) {icon, label, subtitle, view in
            icon.centerY == view.centerY - 30
            label.centerY == view.centerY - 30
        }
    }
    
    func setDownSubtitle(){
        emailLabel.alpha = 0
        if let constraintGroup = constraintGroup { constrain(clear: constraintGroup) }
        constraintGroup = constrain(avatarImageView, titleLabel, emailLabel,contentView) {icon, label, subtitle, view in
            icon.centerY == view.centerY + 30
            label.centerY == view.centerY + 30
        }
    }
}

extension LoggedProfileTableViewCell {
    func setupAvaWithProperties(urlString: String?, name: String?, email: String?) {
        if let url = urlString{
            avatarImageView.kf.setImage(with: URL(string: "\(url)"))}
        titleLabel.text = name
        emailLabel.text = email
    }
}

