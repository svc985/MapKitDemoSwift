//
//  CityDetailsViewController.swift
//  MapKitDemo
//
//  Created by q on 7/22/15.
//  Copyright (c) 2015 Prikic. All rights reserved.
//

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
