//
//  GameViewController+MapViewDelegate.swift
//  MapKitDemo
//
//  Created by q on 7/21/15.
//  Copyright (c) 2015 Prikic. All rights reserved.
//

import Foundation
import MapKit

extension GameViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let annotation = annotation as? City {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //println("info button clicked")
        
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {

        timer?.invalidate()

        let tappedCity = view.annotation as! City
        performSegueWithIdentifier("showCityDetails", sender: tappedCity)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let tappedCity = sender as! City
        
        if segue.identifier == "showCityDetails" {
            if let cityDetailsVC = segue.destinationViewController as? CityDetailsViewController {
                cityDetailsVC.cityName =  tappedCity.title
                cityDetailsVC.cityTrivia = tappedCity.shortDescription
                
            }
        }
    }
    
    @IBAction func dismissCityDetailsVCAndResumeGame(segue: UIStoryboardSegue) {
        //returned to game...
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTimerLabel", userInfo: nil, repeats: true)
    }
    
}














