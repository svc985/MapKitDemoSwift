import MapKit
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var mMapView: MKMapView!
    @IBOutlet weak var mCityLabel: UILabel!
    @IBOutlet weak var mScoreLabel: UILabel!
    @IBOutlet weak var mTimerLabel: UILabel!
    
    var gestureRecognizer = UITapGestureRecognizer()
    
    var cities = [String:City]()
    var currentCity: String = "" {
        
        didSet {
            mCityLabel.text = currentCity
        }
    }
    
    var currentDifficulty:Double = 0
    var score:Int = 0 {
        
        didSet {
            mScoreLabel.text = "\(score)"
        }
    }
    
    var currentLevel = 1
    
    var timer:NSTimer?
    
    let regionRadius: CLLocationDistance = 400000
    
    var isGameOver = false
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mMapView.setRegion(coordinateRegion, animated: true)
    }
    
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
        
        //initial location is Greenwich
        let initialLocation = CLLocation(latitude: 51.2838, longitude: 0)
        //let initialLocation = CLLocation(latitude: 52.5166667, longitude: 13.4)
        
        centerMapOnLocation(initialLocation)
        
        mMapView.delegate = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func loadLevel(currentLevel: Int) {
        
        mMapView.removeAnnotations(mMapView.annotations)
        
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
                    
                    let city = City(name: cityParts[0], andCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), andShortDescription: cityParts[3])
                    
                    cities[city.name] = city
                }
                
            }
        }
        
        let randomNumber = Helper.randomInt(minInt: 0, maxInt: cities.count)
        currentCity = Array(cities.keys)[randomNumber]
        
    }
    
    func handleGesture(gestureRecognizer: UITapGestureRecognizer) {
        
        //MARK: next line to be modified
        if currentLevel == 4 {
            return
        }
        
        var point = gestureRecognizer.locationInView(self.mMapView)
        
        var tapPoint = self.mMapView.convertPoint(point, toCoordinateFromView: self.view)
        
        let point1 = MKMapPointForCoordinate(tapPoint)
        let point2 = MKMapPointForCoordinate(cities[currentCity]!.coordinate)
        let distance = MKMetersBetweenMapPoints(point1, point2)
        
        if currentDifficulty >= distance {
            //println("Success: \(distance)")
            mMapView.addAnnotation(cities[currentCity])
            score++
            
            if let nextCityToDisplay = loadNextCity() {
                currentCity = nextCityToDisplay
            }
            else {
                currentLevel++
                //println("move to level\(currentLevel)")
                createAlertController()
            }
            
        }
        else {
            //println("Fail, currentDifficulty:\(currentDifficulty), distance:\(distance)")
        }
        
    }
    
    func loadNextCity() -> String? {
        
        cities.removeValueForKey(currentCity)
        
        if cities.count == 0 {
            timer?.invalidate()
            //println("mTimerLabel:\(mTimerLabel.text)")
            mTimerLabel.text = "0"
            return nil
        }
        
        let randomInt = Helper.randomInt(minInt:0, maxInt:cities.count)
        
        return Array(cities.keys)[randomInt]
        
    }
    
    func createAlertController() {
        
        let myAlertController = MyAlertController(title: "MapKit game - DEMO",
            message: "Level \(self.currentLevel). Ready?",
            preferredStyle: .Alert)
        myAlertController.addAction(UIAlertAction(title: "OK", style: .Default) { [unowned self] (action) in
            if self.currentLevel < 4 {
                
                self.loadLevel(self.currentLevel)
                self.startTimer()
            }
            
            })
        
        if self.currentLevel < 4 {
            myAlertController.show()
        }
        else {
            let ac = UIAlertController(title: "MapKit game - DEMO", message: "Game finished", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            isGameOver = true
        }
    }
    
    func startTimer() {
        if !isGameOver {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTimerLabel", userInfo: nil, repeats: true)
        }
    }
    
    func updateTimerLabel() {
        
        let timerAsString = self.mTimerLabel.text!
        let timerAsDouble = (timerAsString as NSString).doubleValue + 0.01
        self.mTimerLabel.text = String(format: "%.2f", timerAsDouble)
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
        self.startTimer()
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



