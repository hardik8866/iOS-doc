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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblContactInfo.delegate = self
        tblContactInfo.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
