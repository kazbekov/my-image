//
//  DetailTableViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/29/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

class DetailTableViewCell: UITableViewCell {
    
    lazy var ordererNameLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var bgView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3
    }
    
    lazy var titleLabel: UILabel = {
        return UILabel().then{
            $0.text = "TONY & GUY"
            $0.font = .systemFont(ofSize: 17, weight: 0.5)
            $0.textColor = HexColor("D6375E")
        }
    }()
    
    lazy var infoLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.text = "Косметические услугиТатуажЭпиляция ПарикмахерскиеЖенская стрижка от 1500 тнг.Мужская стрижка от 1500 тнг.Детская стрижкаПлетение косСвадебные прически Ногтевые студииАппаратный маникюрДизайн ногтейГель-лакГельАкрилПарафиновые ванночкиПедикюрМужской маникюр Наличный расчет"
        $0.font = .systemFont(ofSize: 12, weight: 0.001)
    }
    
    var addNotificationButton: UIButton = {
        return UIButton().then {
            $0.setTitle("Добавить уведомление", for: .normal)
            $0.backgroundColor = HexColor("D6375F")
            $0.layer.cornerRadius = 3
//            $0.addTarget(self, action: #selector(addFunc), for: .touchUpInside)
        }
    }()
    
    lazy var stateLabel: UILabel = {
        return UILabel().then{
            $0.text = "Открыто до 18:00"
            $0.font = .systemFont(ofSize: 12, weight: 0.0001)
            $0.textColor = .black
        }
    }()
    
    lazy var stateImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "open")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var checkImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "check")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var priceLabel: UILabel = {
        return UILabel().then{
            $0.text = "3000-7000 тг."
            $0.font = .systemFont(ofSize: 17, weight: 0.0001)
            $0.textColor = HexColor("D6375E")
        }
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleLabel, stateLabel, stateImageView, checkImageView, priceLabel, infoLabel, addNotificationButton].forEach {
            contentView.addSubview($0)
        }
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        contentView.backgroundColor = .clear
    }
    
    func setUpConstraints() {
        constrain(titleLabel, stateLabel, stateImageView, contentView, infoLabel){
            $0.top == $3.top + 15
            $0.leading == $3.leading + 15
            
            $2.centerY == $0.centerY
            $2.trailing == $3.trailing - 15
            
            $1.trailing == $2.leading - 5
            $1.centerY == $2.centerY
            
            $4.top == $0.bottom + 10
            $4.leading == $3.leading + 15
            $4.trailing == $3.trailing - 15
        }
        
        constrain(addNotificationButton, infoLabel, contentView){
            $0.centerX == $2.centerX
            $0.width == $2.width - contentView.width/6
            $0.top == $1.bottom + 15
            $0.bottom == $2.bottom - 15
            $0.height == 44
        }
    }
    
    func addFunc(){
        print(123)
    }
}

