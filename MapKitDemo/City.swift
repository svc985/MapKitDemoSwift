//
//  City.swift
//  MapKitDemo
//
//  Created by q on 6/14/15.
//  Copyright (c) 2015 Prikic. All rights reserved.
//

import UIKit
import MapKit

class City: NSObject, NilLiteralConvertible, MKAnnotation {
    
    var name: String
    var coordinate: CLLocationCoordinate2D
    var shortDescription: String
    
    init(name: String, andCoordinate coordinate: CLLocationCoordinate2D, andShortDescription shortDescription: String) {
        
        self.name = name
        self.coordinate = coordinate
        self.shortDescription = shortDescription
        
        super.init()
    }
    
    required init(nilLiteral: ()) {
        
        name = ""
        coordinate = CLLocationCoordinate2D()
        shortDescription = ""
        
    }
    
    var title: String {
        return name
    }

    
   //MARK: should be deleted ??
    var subtitle: String {
        return name
    }
}
