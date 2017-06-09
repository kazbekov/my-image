//
//  HeaderCollectionReusableView.swift
//  myImage
//
//  Created by Damir Kazbekov on 4/21/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Cartography

class HeaderCollectionReusableView: UICollectionReusableView {
    
    var searchBarContainerView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(searchBarContainerView)
        constrain(searchBarContainerView, self){
            search, view in
            search.edges == view.edges
        }
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
