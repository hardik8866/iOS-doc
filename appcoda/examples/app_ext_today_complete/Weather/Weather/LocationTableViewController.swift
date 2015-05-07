//
//  LocationTableViewController.swift
//  Weather
//
//  Created by Joyce Echessa on 10/18/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    var selectedLocation: Location = .MyLocation
    var defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.appcoda.weather")
    
    func refresh() {
        // hasSetLocation is set in NSUserDefaults to track whether the user has set any other location apart from My Location
        var hasSetOtherLocation: Bool? = defaults.boolForKey("hasSetLocation")
        if let hasSetLoc = hasSetOtherLocation {
            if (hasSetLoc == true) {
                selectedLocation = Location.fromRaw(defaults.integerForKey("location"))!
            }
        }
        
        for i in 0..<Location.NumLocationTypes.toRaw() {
            var cell:UITableViewCell = tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: i, inSection: 0))
            cell.accessoryType = selectedLocation.toRaw() == i ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.refresh()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedLocation = Location.fromRaw(indexPath.row)!
        
        // If other location is selected then set values that will be used in the API call and to populate the view, otherwise the default Cupertino values will be used
        if (selectedLocation != .MyLocation) {
            defaults.setInteger(indexPath.row, forKey: "location")
            defaults.setBool(true, forKey: "hasSetLocation")
            
            let locationData: (String, String) = getLocationData(selectedLocation)
            let locationDictionary = ["name": locationData.0, "latLong": locationData.1]
            
            defaults.setObject(locationDictionary, forKey: "locationData")
        } else {
            defaults.setBool(false, forKey: "hasSetLocation")
        }
        
        
        self.refresh()
    }
    
    func getLocationData(location: Location) -> (String, String) {
        
        switch location {
        case .MicrosoftHQ:
            return ("Redmond, WA", "51.461231,-0.9259415")
        case .FacebookHQ:
            return ("Menlo Park, CA", "37.484765,-122.148549")
        case .GoogleHQ:
            return ("Mountain View, CA", "37.422,-122.084058")
        default:
            // This will never be reached, but switch blocks have to be exhaustive
            return ("", "")
        }
    }
    
    //Redmond, WA 51.461231,-0.9259415
    //Menlo Park, CA 37.484765,-122.148549
    //Mountain View, CA 37.422,-122.084058
    
}

enum Location: Int {
    case MicrosoftHQ = 0
    case FacebookHQ
    case GoogleHQ
    case MyLocation
    case NumLocationTypes
}
