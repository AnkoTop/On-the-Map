//
//  LoginViewController.swift
//  On The Map
//
//  Created by Anko Top on 09/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    var session: NSURLSession!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        session = NSURLSession.sharedSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func startSignUp(sender: UIButton) {
       UIApplication.sharedApplication().openURL(NSURL(string:UdacityClient.Constants.baseSecureURL + UdacityClient.Methods.signUp)!)
    }
    
    
    @IBAction func loginToUdacity(sender: UIButton) {
    // check if email and password are filled
        if loginEmail != "" && loginPassword != "" {
            UdacityClient.sharedInstance().establishSession(loginEmail.text, password: loginPassword.text) { succes, error in
                if succes {
                   // REMOVE THESE LINES
                    println("userinfo after login")
                   println(udacityUser.firstName)
                    println(udacityUser.lastName)
                     println(udacityUser.userId)
                     println(udacityUser.hasStudentLocation)
                     println(udacityUser.objectIdStudentLocation)
                    
                   self.completeLogin()
                } else {
                    println(error)
                  }
             }
        } else {
            println("error")
        }
        
    }
    
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    

}
