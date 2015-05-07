//
//  WeatherData.swift
//  Weather
//
//  Created by Joyce Echessa on 10/16/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import Foundation

public class WeatherData: NSObject {
    
    let currentTime: String
    let temperature: Int
    let humidity: Double
    let precipProbability: Double
    let summary: String
    
    public init(weatherDictionary: NSDictionary) {
        let weather = weatherDictionary["currently"] as NSDictionary
        
        temperature = weather["temperature"] as Int
        humidity = weather["humidity"] as Double
        precipProbability = weather["precipProbability"] as Double
        summary = weather["summary"] as String
        
        let time = weather["time"] as Int
        let timeInterval = NSTimeInterval(time)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        currentTime = dateFormatter.stringFromDate(date)
    }
    
}
