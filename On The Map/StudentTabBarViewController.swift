//
//  StudentTabBarViewController.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit

class StudentTabBarViewController: UITabBarController  {
    
    @IBOutlet weak var logoutFacebook: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // add 2 navagionbutton items on the right side
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshStudentLocations"), UIBarButtonItem(image: UIImage(named: "pin.png"), style: .Plain, target: self, action: "addStudentLocation")]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.logoutFacebook.enabled = true
        } else {
            self.logoutFacebook.enabled = false
        }

    }
    
    @IBAction func logoutFromFacebook(sender: UIBarButtonItem) {
        println("before logout token: \(FBSDKAccessToken.currentAccessToken()) ")
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logOut()
          println("after logout token: \(FBSDKAccessToken.currentAccessToken()) ")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func addStudentLocation(){
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }

   func refreshStudentLocations() {
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

