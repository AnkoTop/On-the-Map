//
//  StudentTabBarViewController.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit

class StudentTabBarViewController: UITabBarController {
    
    @IBAction func refreshStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations() {succes, message, error in
            if !succes {
                var noStudentLocationsAlert = UIAlertController(title: "Student Locations", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                noStudentLocationsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in  //do nothing
                }))
                self.presentViewController(noStudentLocationsAlert, animated: true, completion: nil)
            }
        }
    }
}

