//
//  WeatherDataViewController.swift
//  Weather
//
//  Created by Joyce Echessa on 10/16/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

public class WeatherDataViewController: UIViewController {
    
    @IBOutlet public var temperatureLabel: UILabel!
    @IBOutlet public var summaryLabel: UILabel!
    @IBOutlet public var timeLabel: UILabel!
    @IBOutlet public var humidityLabel: UILabel!
    @IBOutlet public var precipitationLabel: UILabel!
    @IBOutlet public var locationLabel: UILabel!
    
    public var weatherData: WeatherData?
    
    public func updateData() {
        if let unwrappedWD = weatherData {
            self.temperatureLabel.text =  "\(unwrappedWD.temperature)"
            self.summaryLabel.text =  "\(unwrappedWD.summary)"
            self.timeLabel.text =  "\(unwrappedWD.currentTime)"
            self.humidityLabel.text =  "\(unwrappedWD.humidity)"
            self.precipitationLabel.text =  "\(unwrappedWD.precipProbability)"
        }
        
    }
    
    public func getWeatherData(latLong: String, completion: (error: NSError?) -> ()) {
        WeatherService.sharedInstance.fetchWeatherData(latLong, completion: { (data, error) -> () in
        dispatch_async(dispatch_get_main_queue()) {
        self.weatherData = data
        completion(error: error)
        }
        })
    }
    
}

