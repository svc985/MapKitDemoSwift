import Foundation

class Helper: NSObject {
    
    class func randomInt(minInt: Int, maxInt: Int) -> Int{
        
        return Int(arc4random_uniform(UInt32(maxInt)) + UInt32(minInt))
    }
    
}
