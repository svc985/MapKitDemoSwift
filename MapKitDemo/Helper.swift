//
//  Helper.swift
//  MapKitDemo
//
//  Created by q on 6/14/15.
//  Copyright (c) 2015 Prikic. All rights reserved.
//

import Foundation

class Helper: NSObject {
    
    class func randomInt(#minInt: Int, maxInt: Int) -> Int{
        
        return Int(arc4random_uniform(UInt32(maxInt)) + UInt32(minInt))
    }
    
}
