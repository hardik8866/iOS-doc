//
//  TodayViewController.swift
//  Weather Widget
//
//  Created by Joyce Echessa on 10/17/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherDataKit

class TodayViewController: WeatherDataViewController, NCWidgetProviding {
    
    var defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.appcoda.weather")
    var widgetExpanded = false
    var latLong = "37.331793,-122.029584"
    
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBOutlet weak var moreDetailsContainerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        moreDetailsContainerHeightConstraint.constant = 0
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        checkForSetLocation()
        
        getWeatherData(latLong, completion: { (error) -> () in
            if error == nil {
                self.updateData()
                completionHandler(.NewData)
            } else {
                completionHandler(.NoData)
            }
        })
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }
    
    @IBAction func showMore(sender: UIButton) {
        if widgetExpanded {
            moreDetailsContainerHeightConstraint.constant = 0
            showMoreButton.transform = CGAffineTransformMakeRotation(0)
            widgetExpanded = false
        } else {
            moreDetailsContainerHeightConstraint.constant = 220
            showMoreButton.transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
            widgetExpanded = true
        }
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
