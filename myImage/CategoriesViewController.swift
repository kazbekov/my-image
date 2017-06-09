//
//  CategoriesViewController.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/27/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework

class CategoriesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK: -Properties
    lazy var titles = ["ВОЛОСЫ", "КОСМЕТОЛОГИЯ", "НОГТИ", "МЕЙК-АП", "РЕСНИЦЫ", "СОЛЯНЫЕ КОМНАТЫ", "МАССАЖ", "SPA", "САНАТОИИ", "ЗАГАР", "ТОНИЗИРОВАНИЕ"]
    
    lazy var images = [#imageLiteral(resourceName: "vinicius-amano-144838"),#imageLiteral(resourceName: "freestocks-org-209883"),#imageLiteral(resourceName: "blue-lips-and-blue-nails"),#imageLiteral(resourceName: "freestocks-org-209882-2"),#imageLiteral(resourceName: "JJ_Eyelashes_eyelash_extensions_NYC_2"),#imageLiteral(resourceName: "solyanye"),#imageLiteral(resourceName: "leelawadeeMassage"),#imageLiteral(resourceName: "Dollarphotoclub_58101270"),#imageLiteral(resourceName: "Ural11"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "kartinka-3")]
    
    private lazy var cancelButton: UIButton = {
        return UIButton().then{
            $0.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
            $0.sizeToFit()
            $0.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        }
    }()
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "КАТЕГОРИЙ"
        $0.font = .systemFont(ofSize: 17, weight: 0.0001)
    }
    
    private lazy var titleBarView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let categoriesCellIdentifier = "categoriesCellIdentifier"
    let defaults = UserDefaults.standard
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 60, left: 35, bottom: 40, right: 35)
            $0.minimumInteritemSpacing = 30
            $0.minimumLineSpacing = 69
            $0.itemSize = CGSize(width: self.view.frame.width/2 - 57.5, height: self.view.frame.width/2 - 57.5)
        }
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .white
            $0.delegate = self
            $0.dataSource = self
            $0.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: self.categoriesCellIdentifier)
        }
    }()
    
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    //MARK: -Setups
    func setUpViews(){
//        setUpNavBar()
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .default
        view.backgroundColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
        [collectionView, titleBarView, cancelButton, titleLabel].forEach {
            view.addSubview($0)
        }
    }
    func setUpConstraints(){
        constrain(collectionView, view, cancelButton, titleLabel, titleBarView){
            collection, view, cancel, title, bar in
            collection.edges == view.edges
            
            cancel.top == view.top + 20
            cancel.trailing == view.trailing - 20
            
            title.top == view.top + 20
            title.centerX == view.centerX
            
            bar.leading == view.leading
            bar.trailing == view.trailing
            bar.top == view.top
            bar.bottom == cancel.bottom + 10
        }
    }
    
    //MARK: -Actions
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource

extension CategoriesViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (collectionView.dequeueReusableCell(withReuseIdentifier: self.categoriesCellIdentifier,for: indexPath as IndexPath) as! CategoriesCollectionViewCell).then {
            $0.setUpWithTitle(title: titles[indexPath.row], background: images[indexPath.row])
        }
    }
    
}

// MARK: UICollectionViewDelegate

extension CategoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defaults.set(indexPath.row, forKey: "category")
        dismissView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

