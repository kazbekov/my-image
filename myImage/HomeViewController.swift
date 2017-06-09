//
//  HomeViewController.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/2/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework
import CoreLocation
import SVProgressHUD

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    //MARK: -LocationManager
    lazy var titles = ["ВОЛОСЫ", "КОСМЕТОЛОГИЯ", "НОГТИ", "МЕЙК-АП", "РЕСНИЦЫ", "СОЛЯНЫЕ КОМНАТЫ", "МАССАЖ", "SPA", "САНАТОИИ", "ЗАГАР", "ТОНИЗИРОВАНИЕ"]
    var images = [#imageLiteral(resourceName: "one"),#imageLiteral(resourceName: "two"),#imageLiteral(resourceName: "three"),#imageLiteral(resourceName: "four"),#imageLiteral(resourceName: "five"),#imageLiteral(resourceName: "six"),#imageLiteral(resourceName: "seven"),#imageLiteral(resourceName: "eight"),#imageLiteral(resourceName: "nine"),#imageLiteral(resourceName: "ten"),#imageLiteral(resourceName: "eleven")]
    var locationManager:CLLocationManager!
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    let defaults = UserDefaults.standard
    var category =  Int()
    var shouldShowSearchResults = false
    var count = 0
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        //        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    //MARK: -URL encodes
    var barbersURLencode = "%D0%BF%D0%B0%D1%80%D0%B8%D0%BA%D0%BC%D0%B0%D1%85%D0%B5%D1%80%D1%81%D0%BA%D0%B8%D0%B5"
    var cosmeticsURLencode = "%D0%BA%D0%BE%D1%81%D0%BC%D0%B5%D1%82%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%B5+%D1%83%D1%81%D0%BB%D1%83%D0%B3%D0%B8"
    var nailsURLencode = "%D0%BD%D0%BE%D0%B3%D1%82%D0%B5%D0%B2%D1%8B%D0%B5+%D1%81%D1%82%D1%83%D0%B4%D0%B8%D0%B8"
    var makeupArtistURLecnode = "%D1%83%D1%81%D0%BB%D1%83%D0%B3%D0%B8+%D0%B2%D0%B8%D0%B7%D0%B0%D0%B6%D0%B8%D1%81%D1%82%D0%B0"
    var eyelashesURLencode = "%D1%83%D1%81%D0%BB%D1%83%D0%B3%D0%B8+%D0%BF%D0%BE+%D1%83%D1%85%D0%BE%D0%B4%D1%83+%D0%B7%D0%B0+%D1%80%D0%B5%D1%81%D0%BD%D0%B8%D1%86%D0%B0%D0%BC%D0%B8+%2F+%D0%B1%D1%80%D0%BE%D0%B2%D1%8F%D0%BC%D0%B8"
    var saltURLencode = "%D1%81%D0%BE%D0%BB%D1%8F%D0%BD%D1%8B%D0%B5+%D0%BA%D0%BE%D0%BC%D0%BD%D0%B0%D1%82%D1%8B"
    var massageURLencode = "%D1%83%D1%81%D0%BB%D1%83%D0%B3%D0%B8+%D0%BC%D0%B0%D1%81%D1%81%D0%B0%D0%B6%D0%B8%D1%81%D1%82%D0%B0"
    var spaURLencode = "SPA-%D0%BF%D1%80%D0%BE%D1%86%D0%B5%D0%B4%D1%83%D1%80%D1%8B"
    var sanatoriumURLencode = "%D1%81%D0%B0%D0%BD%D0%B0%D1%82%D0%BE%D1%80%D0%B8%D0%B8+%2F+%D0%BF%D1%80%D0%BE%D1%84%D0%B8%D0%BB%D0%B0%D0%BA%D1%82%D0%BE%D1%80%D0%B8%D0%B8"
    var sunburnURLencode = "%D1%81%D1%82%D1%83%D0%B4%D0%B8%D0%B8+%D0%B7%D0%B0%D0%B3%D0%B0%D1%80%D0%B0"
    var toningURLencode = "%D1%82%D0%BE%D0%BD%D0%B8%D0%B7%D0%B8%D1%80%D1%83%D1%8E%D1%89%D0%B8%D0%B5+%D1%81%D0%B0%D0%BB%D0%BE%D0%BD%D1%8B"
    
    //MARK: -Arrays
    var getArray = [[String:String]]()
    var filteredArray = [[String:String]]()
    var outputArray = [String]()
    
    //MARK: -Properties
    private lazy var filterButton: UIButton = {
        return UIButton().then{
            $0.setImage(Icon.filterIcon, for: .normal)
            $0.sizeToFit()
            $0.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        }
    }()
    
    let homeCellIdentifier = "homeCellIdentifier"
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumInteritemSpacing = 10
            $0.minimumLineSpacing = 10
            $0.itemSize = CGSize(width: self.view.frame.width, height: 267)
        }
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = HexColor("ECEEF1")
            $0.delegate = self
            $0.dataSource = self
            $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: self.homeCellIdentifier)
            $0.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        }
    }()
    
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpNavBar()
        setUpConstraints()
        determineMyCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.show()
        setUpNavBar()
        category = defaults.integer(forKey: "category")
        print("CATEGORY: \(category)")
        
        title = titles[category]
        urlRequest(category: category)
    }
    
    //MARK: -Setups
    func setUpViews(){
        SVProgressHUD.setForegroundColor(HexColor("DA3C65"))
        SVProgressHUD.setBackgroundColor(.white)
        UIApplication.shared.isStatusBarHidden = false
        view.backgroundColor = HexColor("ECEEF1")
        UIApplication.shared.statusBarStyle = .lightContent
        [collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    func setUpConstraints(){
        constrain(collectionView, view){
            collection, view in
            collection.edges == view.edges
        }
    }
    
    func setUpNavBar(){
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Главная"
        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
    
    //MARK: -Actions
    func showCategories() {
        present(CategoriesViewController(), animated: true, completion: nil)
    }
    
    func urlRequest(category: Int){
        if self.defaults.object(forKey: "infoArray\(category)") != nil {
            SVProgressHUD.show()
            guard let infoArray = self.defaults.object(forKey: "infoArray\(category)") as? [[String:String]] else {return}
            
            self.getArray = infoArray
            for i in  0...getArray.count-1{
                getArray[i]["route"] = "0"
                guard let longg = getArray[i]["longt"] else {return}
                guard let latt = getArray[i]["lat"] else {return}
                
                getArray[i]["route"] = "\(calculateDistance(lat: latt, long: longg))"
            }
            getArray =  getArray.sorted(by: { Int($1["route"]!)! > Int($0["route"]!)! })
            
            self.collectionView.reloadData()
        } else {
            var urlstringdecodes = [barbersURLencode,cosmeticsURLencode,nailsURLencode,makeupArtistURLecnode,eyelashesURLencode, saltURLencode, massageURLencode, spaURLencode, sanatoriumURLencode, sunburnURLencode, toningURLencode]
            let urlString = "http://sixtynine.gq/myimage/myimage.php?category=\(urlstringdecodes[category])&start=0&count=100"
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with:url!) { (data, response, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    print(error ?? "")
                } else {
                    do {
                        self.getArray = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String:String]]
                        self.defaults.set(self.getArray, forKey: "infoArray\(category)")
                        self.collectionView.reloadData()
                        
                    } catch let error as NSError {
                        SVProgressHUD.dismiss()
                        print(error)
                    }
                }}.resume()
        }
    }
    
    func regularExpression(text: String, regexp: String, check: Bool) -> String{
        return matches(for: regexp, in: text, check: check)
    }
    
    func matches(for regex: String, in text: String, check: Bool) -> String {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            outputArray = results.map { nsString.substring(with: $0.range)}
            if outputArray.count != 0 && check {
                return getOutputFromMatches(forArray: outputArray)
            } else if outputArray.count !=
                0 && !check {
                var time = ""
                if outputArray[1].characters.count < 4 {
                    time = "до 19\(outputArray[1])"
                } else {
                    time = "до \(outputArray[1])"
                }
                return time
            } else if outputArray.count == 0 && !check {
                return "до 19:30"
            } else { return "Уточнить у ад." }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return "Ошибка"
        }
    }
    
    func getOutputFromMatches(forArray: [String]) -> String{
        var intArray = [Int]()
        for i in 0...forArray.count-1{
            intArray.append(Int(forArray[i])!)
        }
        return String(intArray[0])
    }
    
    //MARK: -LocationFunctions
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        lat = userLocation.coordinate.latitude
        long = userLocation.coordinate.longitude
        print("lat \(self.lat)")
        print("lat \(self.long)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
    func calculateDistance(lat: String, long: String) -> Int{
        let coordinate₀ = CLLocation(latitude: self.lat, longitude: self.long)
        let coordinate₁ = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        return Int(round(distanceInMeters/1000))
    }
    
    func reloadCollectionView(){
        self.collectionView.reloadData()
    }
    
    func getFilteredData(data : [[String:String]], ltrToCompare : String ){
        for arr in getArray {
            let filtered = arr.filter { $0.1.lowercased().contains(ltrToCompare.lowercased()) }
            var newData = [String:String]()
            for result in filtered {
                newData[result.0] = result.1
                filteredArray.append(newData)
            }
        }
        reloadCollectionView()
    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "Header",
                                                                             for: indexPath) as! HeaderCollectionReusableView
            headerView.searchBarContainerView.addSubview(searchController.searchBar)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: self.view.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredArray.count
        } else {
            return getArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (collectionView.dequeueReusableCell(withReuseIdentifier: self.homeCellIdentifier,for: indexPath as IndexPath) as! HomeCollectionViewCell).then {
            if searchController.isActive && searchController.searchBar.text != "" {
                $0.addressLabel.text = filteredArray[indexPath.row]["address"]
                $0.titleLabel.text = filteredArray[indexPath.row]["name"]
                guard let price = filteredArray[indexPath.row]["info"] else {return}
                $0.priceLabel.text = "\(regularExpression(text: price, regexp: "\\w*00", check: true)) тг"
                guard let longg = filteredArray[indexPath.row]["longt"] else {return}
                guard let latt = filteredArray[indexPath.row]["lat"] else {return}
                let route = calculateDistance(lat: latt, long: longg)
                $0.routeLabel.text = "\(route) км."
                guard let status = filteredArray[indexPath.row]["schedule"] else {return}
                $0.stateLabel.text = "\(regularExpression(text: status, regexp: "\\w*:[0-3]0", check: false))"
                $0.stateImageView.image = #imageLiteral(resourceName: "open")
                let randomNum:UInt32 = arc4random_uniform(11) // range is 0 to 99
                let someInt:Int = Int(randomNum)
                $0.salonImageView.image = images[someInt]
                SVProgressHUD.dismiss()
            } else if getArray.count != 0 {
                $0.addressLabel.text = getArray[indexPath.row]["address"]
                $0.titleLabel.text = getArray[indexPath.row]["name"]
                guard let price = getArray[indexPath.row]["info"] else {return}
                $0.priceLabel.text = "\(regularExpression(text: price, regexp: "\\w*00", check: true)) тг"
                guard let longg = getArray[indexPath.row]["longt"] else {return}
                guard let latt = getArray[indexPath.row]["lat"] else {return}
                let route = calculateDistance(lat: latt, long: longg)
                if route > 30{
                    $0.routeLabel.text = "0 км."
                } else {
                    $0.routeLabel.text = "\(route) км."
                }
                
                guard let status = getArray[indexPath.row]["schedule"] else {return}
                $0.stateLabel.text = "\(regularExpression(text: status, regexp: "\\w*:[0-3]0", check: false))"
                $0.stateImageView.image = #imageLiteral(resourceName: "open")
                let randomNum:UInt32 = arc4random_uniform(11) // range is 0 to 99
                let someInt:Int = Int(randomNum)

                $0.salonImageView.image = images[someInt]
                SVProgressHUD.dismiss()
            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.homeCellIdentifier,for: indexPath as IndexPath) as! HomeCollectionViewCell
        let detailvc = DetailHomeViewController()
        detailvc.infoDict = getArray[indexPath.row]
        guard let status = getArray[indexPath.row]["schedule"] else {return}
        let statusTime = regularExpression(text: status, regexp: "\\w*:[0-9]0", check: false)
        detailvc.status = statusTime
        guard let longg = getArray[indexPath.row]["longt"] else {return}
        guard let latt = getArray[indexPath.row]["lat"] else {return}
        let route = calculateDistance(lat: latt, long: longg)
        detailvc.route = String(route)
        detailvc.image = cell.salonImageView.image
        self.navigationController?.pushViewController(detailvc, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchBar = searchController.searchBar
        getFilteredData(data: self.getArray, ltrToCompare: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let infoArray = self.defaults.object(forKey: "infoArray\(category)") as? [[String:String]] else {return}
        self.getArray = infoArray
        self.collectionView.reloadData()
        filteredArray = [[:]]
    }
}

