//
//  ViewController.swift
//  MapKitDemo
//
//  Created by q on 6/10/15.
//  Copyright (c) 2015 Prikic. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mMapView: MKMapView!
    @IBOutlet weak var mCityLabel: UILabel!
    
    var gestureRecognizer = UITapGestureRecognizer()
    
    var cities = [City]()
    var currentCity: City = nil
        
    var currentLevel = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleGesture:")
        mMapView.addGestureRecognizer(gestureRecognizer)
        
        loadLevel(currentLevel)
        
        for city in cities {
            println(city.name)
        }
    }
    
    func loadLevel(currentLevel: Int) {
        
        if let filePath = NSBundle.mainBundle().pathForResource("level\(currentLevel)", ofType: "txt") {
            if let text = String(contentsOfFile: filePath, usedEncoding: nil, error: nil) {
                var lines = text.componentsSeparatedByString("\n")
                
                lines.removeAtIndex(0)
                
                for line in lines {
                    let cityParts = line.componentsSeparatedByString(":")
                    
                    let latitudeString: NSString = cityParts[1]
                    let latitude = latitudeString.doubleValue
                    let longitudeString: NSString = cityParts[2]
                    let longitude = longitudeString.doubleValue
                    
                    let city = City(name: cityParts[0], andLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), andShortDescription: cityParts[3])

                    cities.append(city)
                }
                
            }
        }
        
        let randomNumber = Helper.randomInt(minInt: 0, maxInt: cities.count)
        currentCity = cities[randomNumber]
        mCityLabel.text = currentCity.name
        
    }
    
    func handleGesture(gestureRecognizer: UITapGestureRecognizer) {
        
        var point = gestureRecognizer.locationInView(self.mMapView)
  
        var tapPoint = self.mMapView.convertPoint(point, toCoordinateFromView: self.view)
  
        let point1 = MKMapPointForCoordinate(tapPoint)
        let point2 = MKMapPointForCoordinate(currentCity.location)
        let distance = MKMetersBetweenMapPoints(point1, point2)
        
        println(distance)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeMapMode(sender: UIBarButtonItem) {
        
        let buttonTitle = sender.title!
        
        switch buttonTitle {
        
        case "Hybrid":
            
            mMapView.mapType = .Hybrid
        
        case "Satellite":
        
            mMapView.mapType = .Satellite
        
        case "Standard":
            
            mMapView.mapType = .Standard
            
        default:
            
            break
                        
        }
        
            
    }
    
        

}

