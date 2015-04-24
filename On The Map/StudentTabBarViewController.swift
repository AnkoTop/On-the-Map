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
       
        // add 2 navigationbutton items on the right side
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
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func addStudentLocation(){
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }

   func refreshStudentLocations() {
        //refresh of the main-queue
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            ParseClient.sharedInstance().getAllStudentLocations() {succes, message, error in
                dispatch_async(dispatch_get_main_queue()) {
                    if !succes {
                        var noStudentLocationsAlert = UIAlertController(title: "Student Locations", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        noStudentLocationsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in  //do nothing
                        }))
                        self.presentViewController(noStudentLocationsAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}

