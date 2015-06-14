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
    var gestureRecognizer = UITapGestureRecognizer()
    
    var cities = ["","","","","", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleGesture:")
        mMapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleGesture(gestureRecognizer: UITapGestureRecognizer) {
        
        var point = gestureRecognizer.locationInView(self.mMapView)
  
        var tapPoint = self.mMapView.convertPoint(point, toCoordinateFromView: self.view)
  
        println("latitude: \(tapPoint.latitude) longitude\(tapPoint.longitude)")
        
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

