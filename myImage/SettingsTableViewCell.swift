//
//  SettingsTableViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/3/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Cartography

class SettingsTableViewCell: UITableViewCell {
    lazy var ordererNameLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [ordererNameLabel].forEach {
            contentView.addSubview($0)
        }
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        constrain(ordererNameLabel, contentView){ordererNameLabel, contentView in
            ordererNameLabel.center == contentView.center
        }
    }
}
