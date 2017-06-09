//
//  HomeCollectionViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/27/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework

final class HomeCollectionViewCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        return UILabel().then{
            $0.font = .systemFont(ofSize: 17, weight: 0.5)
        }
    }()
    
    lazy var checkImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "check")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var priceLabel: UILabel = {
        return UILabel().then{
            $0.font = .systemFont(ofSize: 17, weight: 0.0001)
            $0.textColor = HexColor("D6375E")
        }
    }()
    
    lazy var addressImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "location")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var addressLabel: UILabel = {
        return UILabel().then{
            $0.font = .systemFont(ofSize: 17, weight: 0.0001)
            $0.textColor = HexColor("D6375E")
        }
    }()
    
    lazy var routeImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "route")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var routeLabel: UILabel = {
        return UILabel().then{
            $0.font = .systemFont(ofSize: 17, weight: 0.0001)
            $0.textColor = HexColor("D6375E")
        }
    }()
    
    lazy var stateLabel: UILabel = {
        return UILabel().then{
            $0.font = .systemFont(ofSize: 12, weight: 0.0001)
            $0.textColor = .black
        }
    }()
    
    lazy var stateImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var salonImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    
    lazy var shadowView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = HexColor("989898")?.cgColor
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 1
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUpViews() {
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        
        [titleLabel, checkImageView, priceLabel, addressImageView, addressLabel, routeImageView, routeLabel, stateLabel, shadowView, salonImageView, stateImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, contentView, checkImageView, priceLabel, stateImageView) {
            $0.top == $1.top + 10
            $0.leading == $1.leading + 20
            
            $2.top == $0.bottom + 15
            $2.leading == $1.leading + 20
            
            $3.top == $2.top
            $3.leading == $2.trailing + 10
            
            $4.centerY == $0.centerY
            $4.trailing == $1.trailing - 20
        }
        
        constrain(addressImageView, addressLabel, checkImageView, salonImageView, contentView) {
            $0.top == $2.bottom + 15
            $0.leading == $2.leading
            
            $1.centerY == $0.centerY
            $1.leading == $0.trailing + 10
            
            $3.top == $0.bottom + 15
            $3.leading == $0.leading
            $3.width == $4.width - 40
            $3.height == 140
        }
        
        constrain(routeImageView, routeLabel, contentView, checkImageView) {
            $1.trailing == $2.trailing - 20
            $1.centerY == $3.centerY
            
            $0.centerY == $1.centerY
            $0.trailing == $1.leading - 10
        }
        constrain(stateLabel, stateImageView, salonImageView, shadowView){
            $0.trailing == $1.leading - 5
            $0.centerY == $1.centerY
            
            $3.center == $2.center
            $3.width == $2.width - 10
            $3.height == $2.height - 10
        }
    }
}
