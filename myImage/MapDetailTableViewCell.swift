//
//  MapDetailTableViewCell.swift
//  myImage
//
//  Created by Dias Dosymbaev on 3/30/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import MapKit
import Cartography
import ChameleonFramework

class MapDetailTableViewCell: UITableViewCell {

    lazy var addressImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "location")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var addressLabel: UILabel = {
        return UILabel().then{
            $0.text = "Алматы, 3-й микрорайон, 65"
            $0.font = .systemFont(ofSize: 12, weight: 0.0001)
            $0.textColor = HexColor("D6375E")
        }
    }()
    
    lazy var routeImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "route")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var routeLabel: UILabel = {
        return UILabel().then{
            $0.text = "1.2 км"
            $0.font = .systemFont(ofSize: 12, weight: 0.0001)
            $0.textColor = HexColor("D6375E")
        }
    }()
    
    lazy var mapView = MKMapView().then{
        $0.mapType = MKMapType.standard
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [mapView, addressImageView, addressLabel, routeLabel, routeImageView].forEach {
            contentView.addSubview($0)
        }
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUpConstraints() {
        constrain(mapView, contentView, addressImageView, addressLabel){
            $2.top == $1.top + 15
            $2.leading == $1.leading + 15
            
            $3.centerY == $2.centerY
            $3.leading == $2.trailing + 15
            
            $0.top == $2.bottom + 15
            $0.leading == $1.leading
            $0.trailing == $1.trailing
            $0.height == 150
            $0.bottom == $1.bottom
        }
        
        constrain(contentView, addressImageView, routeLabel, routeImageView) {
            $2.centerY == $1.centerY
            $2.trailing == $0.trailing - 15
            
            $3.centerY == $2.centerY
            $3.trailing == $2.leading - 15
        }
    }
}

extension MapDetailTableViewCell{
    func setUpViews(lat: Double, long: Double, title: String, subtitle: String){
        let location = CLLocationCoordinate2D(latitude: lat,longitude: long)
        
        // 3)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // 4)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "\(title)"
        annotation.subtitle = "\(subtitle)"
        mapView.addAnnotation(annotation)
        
    }
}

