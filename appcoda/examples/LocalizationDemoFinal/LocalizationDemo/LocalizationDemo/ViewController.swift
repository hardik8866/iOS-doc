//
//  ViewController.swift
//  LocalizationDemo
//
//  Created by Gabriel Theodoropoulos on 30/10/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblMovieInformation: UILabel!
    
    @IBOutlet weak var imgFlag: UIImageView!
    
    @IBOutlet weak var tblMovieInformation: UITableView!
    
    @IBOutlet weak var btnMoviePicker: UIButton!
    
    var moviesData : NSArray?
    
    var selectedMovieIndex : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Make self the delegate and datasource of the tableview.
        tblMovieInformation.delegate = self;
        tblMovieInformation.dataSource = self;
        
        // Set the default selected movie index.
        selectedMovieIndex = 0
        
        // Load the movies data from the .plist file.
        loadMoviesData()
        
        // Set the flag image to the imageview.
        imgFlag.image = UIImage(named: "flag")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func showMoviesList(sender: AnyObject) {
        let moviePicker = UIAlertController(title: "Movies List", message: "Pick a movie", preferredStyle: .ActionSheet)
        
        for var i=0; i<moviesData?.count; ++i{
            let movieDataDictionary : NSDictionary = moviesData?.objectAtIndex(i) as NSDictionary
            let currentMovieIndex = i
            let movieTitle = movieDataDictionary.objectForKey("Movie Title") as String
            
            let normalAction = UIAlertAction(title: movieTitle, style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
                
                self.selectedMovieIndex = currentMovieIndex;
                self.tblMovieInformation.reloadData()
            })
            
            moviePicker.addAction(normalAction)
        }
        
        let closeAction = UIAlertAction(title: NSLocalizedString("Close", comment: "The Close button title"), style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
            
            
        }
        
        moviePicker.addAction(closeAction)
        
        self.presentViewController(moviePicker, animated: true, completion: nil)
    }
    
    
    func loadMoviesData(){
        // Load the movies data. Note that we assume that the file always exists so we don't check it.
        let moviesDataPath = NSBundle.mainBundle().pathForResource("MoviesData", ofType: "plist")
        moviesData = NSArray(contentsOfFile: moviesDataPath!)
    }
    
    
    func getFormattedStringFromNumber(number: Double) -> String{
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        return numberFormatter.stringFromNumber(number)!
    }
    
    
    func getFormattedStringFromDate(aDate: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(aDate)
    }
    
    
    
    //MARK - TableView method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        let movieDataDictionary : NSDictionary = moviesData?.objectAtIndex(selectedMovieIndex!) as NSDictionary
        
        switch indexPath.row{
        case 0:
            // Dequeue the proper cell.
            cell = tableView.dequeueReusableCellWithIdentifier("idCellTitle", forIndexPath: indexPath) as UITableViewCell
            
            // Set the cell's title label text.
            cell.textLabel.text = movieDataDictionary.objectForKey("Movie Title") as? String
            
            
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("idCellCategory", forIndexPath: indexPath) as UITableViewCell
            
            let categoriesArray = movieDataDictionary.objectForKey("Category") as [String]
            var allCategories = String()
            for aCategory in categoriesArray{
                allCategories += NSLocalizedString(aCategory, comment: "The category of the movie") + " "
            }
            
            cell.textLabel.text = allCategories
        
            
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("idCellRating", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel.text = getFormattedStringFromNumber(movieDataDictionary.valueForKey("Rating") as Double) + " / 10"
            
            
        case 3:
            cell = tableView.dequeueReusableCellWithIdentifier("idCellReleaseDate", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel.text = getFormattedStringFromDate(movieDataDictionary.objectForKey("Release Date") as NSDate)
            
            
        case 4:
            cell = tableView.dequeueReusableCellWithIdentifier("idCellDuration", forIndexPath: indexPath) as UITableViewCell
            
            let duration = movieDataDictionary.objectForKey("Duration") as Int
            cell.textLabel.text = String(duration) + " " + NSLocalizedString("minutes", comment: "The minutes literal for the movie duration")
            
            
        case 5:
            cell = tableView.dequeueReusableCellWithIdentifier("idCellDirector", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel.text = movieDataDictionary.objectForKey("Director") as? String
            
            
        case 6:
            cell = tableView.dequeueReusableCellWithIdentifier("idCellStars", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel.text = movieDataDictionary.objectForKey("Stars") as? String
            
            
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("idCellLink", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel.text = movieDataDictionary.objectForKey("Link") as? String
        }
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 7 {
            let movieDataDictionary : NSDictionary = moviesData?.objectAtIndex(selectedMovieIndex!) as NSDictionary
            
            let link = movieDataDictionary.objectForKey("Link") as String
            
            UIApplication.sharedApplication().openURL(NSURL(string: link)!)
        }
    }
}

