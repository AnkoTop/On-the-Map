//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit
import Foundation

extension ParseClient {
    
    func getStudentLocations(completionHandler: (result: [StudentLocation]?, error: NSError?) -> Void) {
    
        var mutableMethod : String = Methods.baseLimit
        var parameters = ""
        
        let task = taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                // REMOVE THIS LINE
                //println(JSONResult)
                
                if let results = JSONResult.valueForKey(ParseClient.JSONResponseKeys.results) as? [[String : AnyObject]] {
                    var studentLocations = StudentLocation.studentLocationFromResults(results)
                    completionHandler(result: studentLocations, error: nil)
                 } else {
                        completionHandler(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                    }
                }
            }
        }
    
    func checkForStudentLocation(completionHandler: (result: Bool, error: NSError?) -> Void) {
    
        var mutableMethod = ""
        let userId = udacityUser.userId
        var parameters = "?where=%7B%22uniqueKey%22%3A%22" + userId + "%22%7D"
        
        let task = taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            if let error = error {
                completionHandler(result: false, error: error)
            } else {
                // REMOVE THIS LINE
                //println(JSONResult)
            
                if let results = JSONResult.valueForKey(ParseClient.JSONResponseKeys.results) as? [[String : AnyObject]] {
                    var studentLocations = StudentLocation.studentLocationFromResults(results)
                    if studentLocations.isEmpty {
                        udacityUser.setStudentLocation(false, objectId: "")
                        completionHandler(result:false, error: nil)
                    } else {
                        let objectId = studentLocations[0].objectId
                        udacityUser.setStudentLocation(true, objectId: objectId)
                    
                        // REMOVE THESE LINES
                        //println(udacityUser.hasStudentLocation)
                        //println(udacityUser.objectIdStudentLocation)
                    
                        completionHandler(result:true, error: nil)
                        }
                } else {
                    completionHandler(result: false, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }




    func pushStudenLocation(studentLocation: StudentLocation, completionHandler: (succes: Bool, error: NSError?) -> Void) {
        // Check if student already has a location
        if udacityUser.hasStudentLocation != nil {
            if udacityUser.hasStudentLocation! {
                // Update: PUT
                putStudentLocation(studentLocation, completionHandler: completionHandler)
            } else {
                // new: POST
               postStudentLocation(studentLocation, completionHandler: completionHandler)
            }
            
        } else {
            // REMOVE THIS LINE & the else branch
            println("SHOULD NOT BE POSSIBLE!")
        }
    }
  
    // create a StudentLocation
    func postStudentLocation(studentLocation: StudentLocation, completionHandler: (succes: Bool, error: NSError?) -> Void) {

        let jsonBody = makeJsonBody(studentLocation)
        println(jsonBody)
        let task = taskForPOSTMethod(jsonBody) { JSONResult, error in
            if let error = error {
                completionHandler(succes: false, error: error)
            } else {
                //REMOVE THIS LINE
                //println(JSONResult)
                
                if let objectId = JSONResult.valueForKey(ParseClient.JSONResponseKeys.objectId) as? String {
                    // OK update the udacityUserData
                    udacityUser.setStudentLocation(true, objectId: objectId)
                    completionHandler(succes: true, error: nil)
                    
                } else {
                    completionHandler(succes: false, error: NSError(domain: "POSTStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse POSTStudentLocation"]))
                }
            }
        }
    }
    
    // update a StudentLocation
    func putStudentLocation(studentLocation: StudentLocation, completionHandler: (succes: Bool, error: NSError?) -> Void) {
        let objectId = udacityUser.objectIdStudentLocation
        let jsonBody = makeJsonBody(studentLocation)
        println(jsonBody)
        let task = taskForPUTMethod(objectId, jsonBody: jsonBody) { JSONResult, error in
            if let error = error {
                completionHandler(succes: false, error: error)
            } else {
                //REMOVE THIS LINE
                //println(JSONResult)
                
                if let updatedAt = JSONResult.valueForKey(ParseClient.JSONResponseKeys.updatedAt) as? String {
                    // OK  udacityUser data stays the same
                    completionHandler(succes: true, error: nil)
                    
                } else {
                    completionHandler(succes: false, error: NSError(domain: "PUTStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse PUTStudentLocation"]))
                }
            }
        }
    }

    
    
    
    // delete a StudentLocation
    func deleteStudentLocation (completionHandler: (succes: Bool, error: NSError?) -> Void) {
        
        let objectId = udacityUser.objectIdStudentLocation
        
        let task = taskForDELETEMethod(objectId) { JSONResult, error in
            if let error = error {
                completionHandler(succes: false, error: error)
            } else {
                // there is no returnmessage if delete succeeded
                completionHandler(succes: true, error: nil)
            }
        }
    }

    
    
    //helpers
     private func makeJsonBody (studentLocation: StudentLocation) -> [String:AnyObject] {
        let jsonBody : [String:AnyObject] = [
            ParseClient.JSONBodyKeys.uniqueKey: udacityUser.userId as String,
            ParseClient.JSONBodyKeys.firstName: udacityUser.firstName as String,
            ParseClient.JSONBodyKeys.lastName: udacityUser.lastName as String,
            ParseClient.JSONBodyKeys.mapString: studentLocation.mapString as String,
            ParseClient.JSONBodyKeys.mediaURL: studentLocation.mediaURL as String,
            ParseClient.JSONBodyKeys.latitude: studentLocation.lattitude as Float!,
            ParseClient.JSONBodyKeys.longitude: studentLocation.longitude as Float!
        ]
        
        return jsonBody
    }
}