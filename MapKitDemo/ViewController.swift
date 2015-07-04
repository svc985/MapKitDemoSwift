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
    @IBOutlet weak var mScoreLabel: UILabel!
    
    var gestureRecognizer = UITapGestureRecognizer()
    
    var cities = [City]()
    var currentCity: City = nil {
        
        didSet {
            mCityLabel.text = currentCity.name
        }
    }
    
    var currentDifficulty:Double = 0 {
    
        didSet {
            
            //println("Current difficulty is now: \(currentDifficulty)")

        }
    }
    
    var score:Int = 0 {
        
        didSet {
            mScoreLabel.text = "\(score)"
        }
    }
            
    var currentLevel = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        currentDifficulty = userDefaults.doubleForKey("idMultiValue") as Double
        
        let observer = NSNotificationCenter.defaultCenter().addObserverForName(NSUserDefaultsDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] (notification) -> Void in
            
            var userDefaults = NSUserDefaults.standardUserDefaults()
            self.currentDifficulty = userDefaults.doubleForKey("idMultiValue") as Double
            
        }

        gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleGesture:")
        mMapView.addGestureRecognizer(gestureRecognizer)
        
        createAlertController()
        
//        dispatch_async(dispatch_get_main_queue()) {
//        
//            var ac = UIAlertController(title: "MapKit game - DEMO", message: "Level \(self.currentLevel). Ready?", preferredStyle: .Alert)
//            var okAction = UIAlertAction(title: "OK", style: .Cancel) { [unowned self] (action) in
//                self.loadLevel(self.currentLevel)
//            }
//            ac.addAction(okAction)
//            
//            //UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(ac, animated: true, completion: nil)
//            self.presentViewController(ac, animated: true, completion: nil)
//        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
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
        
        currentCity = cities[Helper.randomInt(minInt: 0, maxInt: cities.count)]
        
    }
    
    func handleGesture(gestureRecognizer: UITapGestureRecognizer) {
        
        //MARK: next line to be removed
        if currentLevel == 3 {
            return
        }
        
        var point = gestureRecognizer.locationInView(self.mMapView)
  
        var tapPoint = self.mMapView.convertPoint(point, toCoordinateFromView: self.view)
  
        let point1 = MKMapPointForCoordinate(tapPoint)
        let point2 = MKMapPointForCoordinate(currentCity.location)
        let distance = MKMetersBetweenMapPoints(point1, point2)
        
        if currentDifficulty >= distance {
            //println("Success")
            score++
            if let nextCityToDisplay = loadNextCity() {
                currentCity = nextCityToDisplay
            }
            else {
                currentLevel++
                println("move to level\(currentLevel)")
                
                createAlertController()
                //loadLevel(++currentLevel)
            }
        
        }
        else {
            //println("Fail, cD\(currentDifficulty), distance:\(distance)")
        }
        
    }
    
    func loadNextCity() -> City? {
        
        if cities.count == 0 {
            return nil
        }
        
        var index = 0
        
        for city in cities {
            
            if city.name == currentCity.name {
                break
            }
                
            else {
                index++
            }
            
        }
        
        let removedCity = cities.removeAtIndex(index)
        
        if cities.count == 0 {
            return nil
        }
        
        var randomInt = Helper.randomInt(minInt:0, maxInt:cities.count)
        
        return cities[randomInt]
        
    }
    
    func createAlertController() {
    
        let myAlertController = MyAlertController(title: "MapKit game - DEMO",
            message: "Level \(self.currentLevel). Ready?",
            preferredStyle: .Alert)
        myAlertController.addAction(UIAlertAction(title: "OK", style: .Default) { [unowned self] (action) in
            if self.currentLevel < 3 {
                self.loadLevel(self.currentLevel)
            }
            
            })
        
        myAlertController.show()

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

