import UIKit

class CityDetailsViewController: UIViewController {
    
    var cityName: String?
    var cityTrivia: String?

    @IBOutlet weak var mCityName: UINavigationItem!
    @IBOutlet weak var mCityTriviaLabel: UITextView!
    @IBOutlet weak var mCityImage: UIImageView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        mCityName.title = cityName
        mCityTriviaLabel.text = cityTrivia
        
    }

}
