//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func establishSession(username: String, password: String, completionHandler: (succes: Bool, error: NSError?) -> Void) {
        
        var mutableMethod : String = Methods.signIn
        let jsonBody : [String:AnyObject] = [
            UdacityClient.JSONBodyKeys.udacity : [
            UdacityClient.JSONBodyKeys.userName: username,
            UdacityClient.JSONBodyKeys.passWord: password]
            ]
        
        let task = taskForPOSTMethod(mutableMethod, jsonBody: jsonBody) { JSONResult, error in
            
            if let error = error {
                completionHandler(succes: false, error: error)
            } else {
                if let accountDictionary = JSONResult.valueForKey(UdacityClient.JSONResponseKeys.account) as? NSDictionary {
                    if let userID = accountDictionary.valueForKey(UdacityClient.JSONResponseKeys.userID) as? String {
                        self.getUserData(userID) {succes, error in
                            if succes {
                                completionHandler(succes: true, error: nil)
                            } else {
                                completionHandler(succes: false, error: nil)
                                println("error")
                                }
                            }
                    } else {
                        completionHandler(succes: false, error: NSError(domain: "postSessionToUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postSessionToUdacity"]))
                    }
                }
            }
        }
    }
    
    
    // getUserData is made private so it can only be accessed from this file
    private func getUserData(userID: String, completionHandler: (succes: Bool, error: NSError?) -> Void) {
        
        var mutableMethod : String = Methods.getUserData + userID
        
        let task = taskForGETMethod(mutableMethod) { JSONResult, error in
            
            if let error = error {
                completionHandler(succes: false, error: error)
            } else {
                if let userDictionary = JSONResult.valueForKey(UdacityClient.JSONResponseKeys.user) as? NSDictionary {
                        let firstName = userDictionary.valueForKey(UdacityClient.JSONResponseKeys.firstName) as! String
                        let lastName = userDictionary.valueForKey(UdacityClient.JSONResponseKeys.lastName) as! String
                        udacityUser.setDataUdacityUser(firstName, lastName: lastName, userId: userID)
                    
                        // REMOVE THESE LINES
//                        println(udacityUser.firstName)
//                        println(udacityUser.lastName)
//                        println(udacityUser.userId)
                    
                        completionHandler(succes: true, error: nil)
                    } else {
                        completionHandler(succes: false, error: NSError(domain: "postSessionToUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postSessionToUdacity"]))
                    }
                }
            }
        }
    }

