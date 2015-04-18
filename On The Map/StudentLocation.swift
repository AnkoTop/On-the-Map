//
//  StudentLocation.swift
//  ProtoOnTheMap
//
//  Created by Anko Top on 03/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import Foundation


// Global accesible data
let StudentLocationNotificationKey = "nl.reactivity.StudentLocationNotificationKey"
var globalStudentLocations = [StudentLocation]() {
    didSet{
        //send a notifaction that the data has changed
         NSNotificationCenter.defaultCenter().postNotificationName(StudentLocationNotificationKey, object: nil )
    }
}

struct StudentLocation {
    var objectId = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var lattitude: Float?
    var longitude: Float?
    var createdAt: NSDate?
    var updatedAt: NSDate?
    
    
    init () {
        // default constructor
    }
    
    // Construct a StudenLocation from a dictionary
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[ParseClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as! String
        lattitude = dictionary[ParseClient.JSONResponseKeys.latitude] as? Float
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as? Float
        createdAt = dictionary[ParseClient.JSONResponseKeys.createdAt] as? NSDate
        updatedAt = dictionary[ParseClient.JSONResponseKeys.updatedAt] as? NSDate
    }
    
    // Helper: Given an array of dictionaries, convert them to an array of StudenLocation
    static func studentLocationFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
   
}