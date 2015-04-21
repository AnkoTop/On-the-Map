//
//  LoginViewController.swift
//  On The Map
//
//  Created by Anko Top on 09/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    var session: NSURLSession!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.hidesWhenStopped = true
        self.loginEmail.delegate = self
        self.loginPassword.delegate = self
        self.facebookLoginButton.delegate = self;

        // Do any additional setup after loading the view.
        session = NSURLSession.sharedSession()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        // Check if user is logged in with facebook
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.loginToUdacityWithFacebook(FBSDKAccessToken.currentAccessToken().tokenString)
       }
    }
 
 
    @IBAction func startSignUp(sender: UIButton) {
       UIApplication.sharedApplication().openURL(NSURL(string:UdacityClient.Constants.baseSecureURL + UdacityClient.Methods.signUp)!)
    }
    
    
    func loginToUdacityWithFacebook(token: String) {
             UdacityClient.sharedInstance().establishFBTokenSession(token) { succes, message, error in
            if succes {
                self.completeLogin()
            } else {
                self.showLoginFailedAlert(message)
            }
        }
    }
    
    @IBAction func loginToUdacity(sender: UIButton) {
        self.view.endEditing(true)
        // check if email and password are filled
        if loginEmail.text != "" && loginPassword.text != "" {
            self.activityIndicator.startAnimating()
            UdacityClient.sharedInstance().establishSession(loginEmail.text, password: loginPassword.text) { succes, message, error in
                if succes {
                   self.completeLogin()
                } else {
                   self.showLoginFailedAlert(message)
                  }
             }
        } else {
           self.showLoginFailedAlert("Both email and password must be filled!")
        }
    }
    
    func showLoginFailedAlert(message: String){
        
        var loginAlert = UIAlertController(title: "Login failed", message: message, preferredStyle:   UIAlertControllerStyle.Alert)
        loginAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in self.activityIndicator.stopAnimating()
        }))
        presentViewController(loginAlert, animated: true, completion: nil)
    }
    
    
    func completeLogin() {
        self.activityIndicator.stopAnimating()
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    //textfield delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Facebook delegate
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
         if ((error) != nil) {
            self.showLoginFailedAlert("Facebook login failed")
        } else {
           self.loginToUdacityWithFacebook(FBSDKAccessToken.currentAccessToken().tokenString)
        }
    }

    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // no action
    }

}
