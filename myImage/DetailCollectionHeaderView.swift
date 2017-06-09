//
//  DetailCollectionHeaderView.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/28/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
//import RSKPlaceholderTextView

protocol DetailCollectionHeaderViewDelegate {
//    func didSaveProfile()
}

final class DetailCollectionHeaderView: UIView {
    
    var delegate: DetailCollectionHeaderViewDelegate?
    
    lazy var profileBackroundImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "tony")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        [profileBackroundImageView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(profileBackroundImageView, self) { profileBackroundImageView, view in
            profileBackroundImageView.edges == view.edges
        }
    }
    
}

