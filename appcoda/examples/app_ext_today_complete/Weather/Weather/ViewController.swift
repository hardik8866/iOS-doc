//
//  ViewController.swift
//  Weather
//
//  Created by Joyce Echessa on 10/16/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit
import WeatherDataKit

class ViewController: WeatherDataViewController {
    
    var defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.appcoda.weather")
    var latLong = "37.331793,-122.029584"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureLabel.text = "--"
        summaryLabel.text = "--"
        timeLabel.text = "--"
        humidityLabel.text = "--"
        precipitationLabel.text = "--"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkForSetLocation()
        
        getWeatherData(latLong, completion: { (error) -> () in
            if error == nil {
                self.updateData()
            }
        })
    }
    
    func checkForSetLocation() {
        // hasSetLocation is set in NSUserDefaults to track whether the user has set any other location apart from My Location
        var hasSetOtherLocation: Bool? = defaults.boolForKey("hasSetLocation")
        if let hasSetLoc = hasSetOtherLocation {
            if (hasSetLoc == true) {
                let locationDict: NSDictionary? = defaults.objectForKey("locationData") as? NSDictionary
                if let dictionary = locationDict {
                    locationLabel.text = dictionary["name"] as? String
                    latLong = dictionary["latLong"] as String
                }
            }
        }
    }
}

