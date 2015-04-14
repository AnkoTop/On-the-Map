//
//  StudentLocationTableViewController.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource  {

    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    @IBOutlet var studentLocationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

   }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        studentLocations = (self.tabBarController as! StudentTabBarViewController).studentLocations
        dispatch_async(dispatch_get_main_queue()) {
            self.studentLocationTableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as! UITableViewCell
        
        cell.textLabel!.text = student.firstName + " " + student.lastName
        cell.detailTextLabel!.text = student.mediaURL
      

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // when a row is selected" open the url from the student
        let student = studentLocations[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string:student.mediaURL)!)
        
    }

}
