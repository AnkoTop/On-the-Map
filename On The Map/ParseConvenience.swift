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
    
    func getAllStudentLocations(completionHandler: (succes:Bool, message: String, error: NSError?) -> Void) {
        // get the first batch
        getStudentLocations(Methods.limit, skip: 0, completionHandler: completionHandler)
     }
 
    func getStudentLocations (limit: Int, skip: Int, completionHandler: (succes:Bool, message: String, error: NSError?) -> Void) {
        let mutableMethod = Methods.limitResults + String(limit) + Methods.skipResults + String(skip)
        
        let task = taskForGETMethod(mutableMethod) { JSONResult, error in
            if let error = error {
                completionHandler(succes: false, message: "Error in Network connection", error: error)
            } else {
                if let results = JSONResult.valueForKey(ParseClient.JSONResponseKeys.results) as? [[String : AnyObject]] {
                    let studentLocations = StudentLocation.studentLocationFromResults(results)
                    // update the StudentLocations
                    globalStudentLocations += studentLocations
                    // If necessary recursively call self to get the next batch of locations
                    if studentLocations.count == Methods.limit {
                        let nextSkip = skip + Methods.skip
                        self.getStudentLocations(Methods.limit, skip: nextSkip, completionHandler: completionHandler)
                    } else {
                        completionHandler(succes: true, message: "", error: nil)
                    }
                } else {
                    completionHandler(succes: false, message:"Error parsing result", error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    
    func checkForStudentLocation(completionHandler: (result: Bool, error: NSError?) -> Void) {
        let userId = udacityUser.userId
        let mutableMethod = Methods.searchOnUserPart1 + userId + Methods.searchOnUserPart2
        
        let task = taskForGETMethod(mutableMethod) { JSONResult, error in
            if let error = error {
                completionHandler(result: false, error: error)
            } else {
               if let results = JSONResult.valueForKey(ParseClient.JSONResponseKeys.results) as? [[String : AnyObject]] {
                    var studentLocations = StudentLocation.studentLocationFromResults(results)
                    if studentLocations.isEmpty {
                        udacityUser.setStudentLocation(false, objectId: "")
                        completionHandler(result:false, error: nil)
                    } else {
                        let objectId = studentLocations[0].objectId
                        udacityUser.setStudentLocation(true, objectId: objectId)
                        completionHandler(result:true, error: nil)
                    }
                } else {
                    completionHandler(result: false, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }


    func pushStudenLocation(studentLocation: StudentLocation, completionHandler: (succes: Bool, message: String, error: NSError?) -> Void) {
        // Check if student already has a location
        if udacityUser.hasStudentLocation != nil {
            if udacityUser.hasStudentLocation! {
                // Update: PUT
                putStudentLocation(studentLocation, completionHandler: completionHandler)
            } else {
                // new: POST
               postStudentLocation(studentLocation, completionHandler: completionHandler)
            }
        }
    }
  
    // add a new StudentLocation
    func postStudentLocation(studentLocation: StudentLocation, completionHandler: (succes: Bool, message: String, error: NSError?) -> Void) {

        let jsonBody = makeJsonBody(studentLocation)
        let task = taskForPOSTMethod(jsonBody) { JSONResult, error in
            if let error = error {
                completionHandler(succes: false, message: "Error in Network connection", error: error)
            } else {
              if let objectId = JSONResult.valueForKey(ParseClient.JSONResponseKeys.objectId) as? String {
                    // OK update the udacityUserData
                    udacityUser.setStudentLocation(true, objectId: objectId)
                    // and refresh the locations list
                    self.getAllStudentLocations(completionHandler)
                completionHandler(succes: true, message: "", error: nil)
                 } else {
                completionHandler(succes: false, message: "Error parsing result", error: NSError(domain: "POSTStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse POSTStudentLocation"]))
                }
            }
        }
    }
    
    // update a StudentLocation
    func putStudentLocation(studentLocation: StudentLocation, completionHandler: (succes: Bool, message: String, error: NSError?) -> Void) {
        let objectId = udacityUser.objectIdStudentLocation
        let jsonBody = makeJsonBody(studentLocation)
        
        let task = taskForPUTMethod(objectId, jsonBody: jsonBody) { JSONResult, error in
            if let error = error {
                completionHandler(succes: false, message: "Error in Network connection", error: error)
            } else {
                if let _ = JSONResult.valueForKey(ParseClient.JSONResponseKeys.updatedAt) as? String {
                    // OK  udacityUser data stays the same only refresh the list
                    self.getAllStudentLocations(completionHandler)
                    completionHandler(succes: true, message: "",error: nil)
                 } else {
                    completionHandler(succes: false, message: "Error parsing result", error: NSError(domain: "PUTStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse PUTStudentLocation"]))
                }
            }
        }
    }

    
    // delete a StudentLocation
    func deleteStudentLocation (completionHandler: (succes: Bool, message: String, error: NSError?) -> Void) {
        let objectId = udacityUser.objectIdStudentLocation
        
        let task = taskForDELETEMethod(objectId) { JSONResult, error in
            if let error = error {
                completionHandler(succes: false, message: "Error in Network connection", error: error)
            } else {
                // there is no returnmessage if delete succeeded; update the userdata
                udacityUser.setStudentLocation(false, objectId: "")
                // refresh the list
                self.getAllStudentLocations(completionHandler)
            }
        }
    }
    
    
    // MARK: - Helper: fabricate jsonBody
     private func makeJsonBody (studentLocation: StudentLocation) -> [String:AnyObject] {
        let jsonBody : [String:AnyObject] = [
            ParseClient.JSONBodyKeys.uniqueKey: udacityUser.userId as String,
            ParseClient.JSONBodyKeys.firstName: udacityUser.firstName as String,
            ParseClient.JSONBodyKeys.lastName: udacityUser.lastName as String,
            ParseClient.JSONBodyKeys.mapString: studentLocation.mapString as String,
            ParseClient.JSONBodyKeys.mediaURL: studentLocation.mediaURL as String!,
            ParseClient.JSONBodyKeys.latitude: studentLocation.lattitude as Float!,
            ParseClient.JSONBodyKeys.longitude: studentLocation.longitude as Float!
        ]
        
        return jsonBody
    }
}