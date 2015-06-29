//
//  City.swift
//  MapKitDemo
//
//  Created by q on 6/14/15.
//  Copyright (c) 2015 Prikic. All rights reserved.
//

import UIKit
import MapKit

class City: NSObject, NilLiteralConvertible {
    
    var name: String
    var location: CLLocationCoordinate2D
    var shortDescription: String
    
    init(name: String, andLocation location: CLLocationCoordinate2D, andShortDescription shortDescription: String) {
        
        self.name = name
        self.location = location
        self.shortDescription = shortDescription
    }
    
    required init(nilLiteral: ()) {
        
        name = ""
        location = CLLocationCoordinate2D()
        shortDescription = ""
        
    }
    
}

