//
//  CategoriesCollectionViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/27/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework

final class CategoriesCollectionViewCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        return UILabel().then{
            $0.text = "ВОЛОСЫ"
            $0.font = .systemFont(ofSize: 12, weight: 0.5)
            $0.textColor = .white
        }
    }()
    
    lazy var dimView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.4
        $0.clipsToBounds = true
    }
    
    lazy var bgImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = #imageLiteral(resourceName: "vinicius-amano-144838")
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
        //        imageView.image = nil
    }
    
    private func setUpViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = self.frame.width/2
        contentView.clipsToBounds = true
        
        [bgImageView, dimView, titleLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, contentView, dimView, bgImageView) {
            $0.center == $1.center
            
            $2.edges == $1.edges
            
            $3.edges == $1.edges
        }
    }
    
}

extension CategoriesCollectionViewCell {
    func setUpWithTitle(title: String, background: UIImage) {
        titleLabel.text = title
        bgImageView.image = background
    }
}
