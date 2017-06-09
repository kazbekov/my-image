//
//  ContactsDetailTableViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/30/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

class ContactsDetailTableViewCell: UITableViewCell {
    
    lazy var addressImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "location")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var addressLabel: UILabel = {
        return UILabel().then{
            $0.text = "tattoo-status.kz"
            $0.font = .systemFont(ofSize: 12, weight: 0.0001)
            $0.textColor = HexColor("D6375E")
        }
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [addressImageView, addressLabel].forEach {
            contentView.addSubview($0)
        }
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
    }
    
    func setUpConstraints() {
        constrain(contentView, addressImageView, addressLabel){
            $1.leading == $0.leading + 15
            $1.top == $0.top + 15
            $1.bottom == $0.bottom - 15
            
            $2.leading == $1.trailing + 15
            $2.centerY == $1.centerY
        }
    }
}

extension ContactsDetailTableViewCell {
    func setUpWithProperties(title: String, icon: UIImage) {
        addressLabel.text = title
        addressImageView.image = icon
    }
}

