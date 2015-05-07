//
//  ViewContactViewController.swift
//  HandoffDemo
//
//  Created by Gabriel Theodoropoulos on 17/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit


class ViewContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblContactInfo: UITableView!
    
    var contact: Contact!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblContactInfo.delegate = self
        tblContactInfo.dataSource = self
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userInfo = userActivity?.userInfo {
            contact = Contact()
            contact.getContactDataFromDictionary(userInfo)
            
            tblContactInfo.reloadData()
        }
        
        createUserActivity()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "idUnwindSegueViewContact" {
            self.userActivity?.invalidate()
        }
    }
    

    
    // MARK: UITableView method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let validContact = contact{
            return 4
        }
        else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("idCellContact") as UITableViewCell
        
        switch indexPath.row{
        case 0:
            cell.textLabel.text = contact.firstname!
            cell.detailTextLabel?.text = "First name"
            
        case 1:
            cell.textLabel.text = contact.lastname!
            cell.detailTextLabel?.text = "Last name"
            
        case 2:
            cell.textLabel.text = contact.phoneNumber!
            cell.detailTextLabel?.text = "Phone number"
            
        default:
            cell.textLabel.text = contact.email!
            cell.detailTextLabel?.text = "E-mail"
        }
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    
    // MARK: Method implementation
    
    func createUserActivity() {
        userActivity = NSUserActivity(activityType: "com.appcoda.handoffdemo.view-contact")
        userActivity?.title = "View Contact"
        userActivity?.becomeCurrent()
    }
    
    
    override func updateUserActivityState(activity: NSUserActivity) {
        userActivity?.userInfo = contact.getDictionaryFromContactData()
        
        super.updateUserActivityState(activity)
    }
    
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        userActivity = activity

        super.restoreUserActivityState(activity)
    }
    
}

