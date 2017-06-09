//
//  DurationButton.swift
//  Imbra
//
//  Created by Damir Kazbekov on 17.08.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

final class SaveButton
: UIButton {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = HexColor("DA3C65")?.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 18)
        label.text = "Сохранить"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 2
        [textLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setUpConstrains(){
        constrain(textLabel, self) {
            $0.edges == $1.edges
        }
    }
}
