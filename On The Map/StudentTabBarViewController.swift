//
//  StudentTabBarViewController.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit

class StudentTabBarViewController: UITabBarController {
   
    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //REMOVE THIS LINE
        //println("view will appear in TAB controller")
        
        
        // get a list of (100) student locations
        ParseClient.sharedInstance().getStudentLocations() {studentLocations, error in
            if let err = error {
                println(err)
            } else {self.studentLocations = studentLocations!}
        }
        
        // check if there is an existing studentLocation
        if udacityUser.hasStudentLocation == nil {
            ParseClient.sharedInstance().checkForStudentLocation(){ result, error in
                // do nothing
            }
        }
        
    }
    
    @IBAction func refreshStudentLocations() {
        
        // get a list of (100) student locations
        ParseClient.sharedInstance().getStudentLocations() {studentLocations, error in
            if let err = error {
                println(err)
            } else {self.studentLocations = studentLocations!}
        }
        
    }
    
}

