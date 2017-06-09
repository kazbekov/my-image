//
//  SideMenuTableViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/25/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class SideMenuTableViewCell: UITableViewCell {
    
    fileprivate var constraintGroup: ConstraintGroup?
    
    lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18)
        $0.text = "This is title"
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.text = "Регистрация может синхронизировать и сохранить ваши данные"
        $0.alpha = 0
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
        [iconImageView, titleLabel].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(iconImageView, titleLabel, contentView) { icon, label, view in
            icon.leading == view.leading + 15
            icon.centerY == view.centerY
            
            label.leading == icon.trailing + 15
            label.centerY == view.centerY
        }
    }
}

extension SideMenuTableViewCell {
    func setupWithProperties(icon: UIImage?, title: String?) {
        iconImageView.image = icon
        titleLabel.text = title
    }
    
    func setUpSubtitle() {
        subtitleLabel.alpha = 0.6
        if let constraintGroup = constraintGroup { constrain(clear: constraintGroup) }
        constraintGroup = constrain(iconImageView, titleLabel, subtitleLabel,contentView) {icon, label, subtitle, view in
            icon.centerY == view.centerY
            label.centerY == view.centerY
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
