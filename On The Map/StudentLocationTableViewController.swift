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
        
        // get a list of (100) student locations
        ParseClient.sharedInstance().getStudentLocations() {succes, message, error in
            if succes {
                self.studentLocations = globalStudentLocations
            } else {
                var noStudentLocationsAlert = UIAlertController(title: "Student Locations", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                noStudentLocationsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in  //do nothing
                }))
                self.presentViewController(noStudentLocationsAlert, animated: true, completion: nil)
            }
        }
        
        // check if there is an existing studentLocation
        if udacityUser.hasStudentLocation == nil {
            ParseClient.sharedInstance().checkForStudentLocation(){ result, error in
                // do nothing
            }
        }
        
        // Listen for updates of the StudenLocation data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView", name: StudentLocationNotificationKey , object: nil)
    }
    
    
    func updateTableView(){
        self.studentLocations = globalStudentLocations
        dispatch_async(dispatch_get_main_queue()) {
            self.studentLocationTableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.studentLocations = globalStudentLocations
    }
    
    // Tableview delegates
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as! UITableViewCell
        
        cell.textLabel!.text = student.firstName + " " + student.lastName
        cell.detailTextLabel!.text = student.mediaURL

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // when a row is selected: open the url from the student
        let student = studentLocations[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string:student.mediaURL)!)
    }

}
