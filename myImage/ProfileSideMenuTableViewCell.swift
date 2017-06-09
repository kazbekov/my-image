//
//  ProfileSideMenuTableViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/26/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class ProfileSideMenuTableViewCell: UITableViewCell {
    
    fileprivate var constraintGroup: ConstraintGroup?
    
    lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "bg-rose")
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 18)
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.text = "Регистрация может \nсинхронизировать и сохранить \nваши данные"
        $0.alpha = 0.7
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
        [iconImageView, titleLabel, subtitleLabel].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(iconImageView, titleLabel, subtitleLabel, contentView) { icon, label, subtitleLabel, view in
            icon.leading == view.leading + 15
            icon.top == view.top + 40
            
            label.leading == icon.trailing + 15
            label.top == view.top + 40
            
            subtitleLabel.top == label.bottom + 15
            subtitleLabel.leading == icon.leading
        }
    }
}

extension ProfileSideMenuTableViewCell {
    func setupWithProperties(icon: UIImage?, title: String?) {
        iconImageView.image = icon
        titleLabel.text = title
    }
    
    func setUpSubtitle() {
        subtitleLabel.alpha = 0.6
        if let constraintGroup = constraintGroup { constrain(clear: constraintGroup) }
        constraintGroup = constrain(iconImageView, titleLabel, subtitleLabel,contentView) {icon, label, subtitle, view in
            icon.centerY == view.centerY - 30
            label.centerY == view.centerY - 30
        }
    }
    
    func setDownSubtitle(){
        subtitleLabel.alpha = 0
        if let constraintGroup = constraintGroup { constrain(clear: constraintGroup) }
        constraintGroup = constrain(iconImageView, titleLabel, subtitleLabel,contentView) {icon, label, subtitle, view in
            icon.centerY == view.centerY + 30
            label.centerY == view.centerY + 30
        }
    }
}

