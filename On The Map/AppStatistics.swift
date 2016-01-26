//
//  AppStatistics.swift
//  On The Map
//
//  Created by Anko Top on 23/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import Foundation
import CoreLocation

class AppStatistics: NSObject {
    
    static let totalStudentLocations = "totalStudentLocations"
    static let totalUniqueStudents = "totalUniqueStudents"
    static let totalUserLocations = "totalUserLocations"
    static let totalValidUrls = "totalValidUrls"
    static let totalInvalidUrls = "totalInvalidUrls"
    static let averageDistanceToUdacityHQ = "averageDistanceToUdacityHQ"
    static let minDistanceToUdacityHQ = "minDistanceToUdacityHQ"
    static let nameMinDistanceToUdacityHQ = "nameMinDistanceToUdacityHQ"
    static let maxDistanceToUdacityHQ = "maxDistanceToUdacityHQ"
    static let nameMaxDistanceToUdacityHQ = "nameMaxDistanceToUdacityHQ"
    
    
    func returnStatistics() -> [String:String] {
 
        var statistics = [String: String]()
        var uniqueStudents = Set<String>()
        
        var minDistance = 999999
        var maxDistance = 0
        var minName = ""
        var maxName = ""
        var userLocationCount = 0
        var validUrlsCount = 0
        var invalidUrlsCount = 0
        var totalDistance = 0.0
        
        // get the statistics based on all available studentLocations
        let studentLocations = globalStudentLocations
        
        for location in studentLocations {
           
            uniqueStudents.insert(location.uniqueKey)
            
            if location.mediaURL!.lowercaseString.hasPrefix("http://") ||
                location.mediaURL!.lowercaseString.hasPrefix("https://") {
                    validUrlsCount += 1
            } else {
                invalidUrlsCount += 1
            }
            
        
            if location.uniqueKey == udacityUser.userId {
                userLocationCount += 1
            }
            
            // Distance Calculations
            let position = CLLocation(latitude: CLLocationDegrees(location.lattitude!),longitude: CLLocationDegrees(location.longitude!))
            let distance = Int(position.distanceFromLocation(UdacityClient.Constants.location)/1000.0)
            if distance < minDistance {
                minDistance = distance
                minName = location.firstName + " " + location.lastName
            }
            
            if distance > maxDistance {
                maxDistance = distance
                maxName = location.firstName + " " + location.lastName
            }
            
            totalDistance += position.distanceFromLocation(UdacityClient.Constants.location)
        }
        
        let average = Int((totalDistance / Double(studentLocations.count)) / 1000)
        
        
        //fill the dictionary to return
        statistics [AppStatistics.totalStudentLocations] = String(studentLocations.count)
        statistics [AppStatistics.totalUniqueStudents] = String(uniqueStudents.count)
        statistics [AppStatistics.totalUserLocations] = String(userLocationCount)
        statistics [AppStatistics.totalValidUrls] = String(validUrlsCount)
        statistics [AppStatistics.totalInvalidUrls] = String(invalidUrlsCount)
        statistics [AppStatistics.averageDistanceToUdacityHQ] = String(average)
        statistics [AppStatistics.minDistanceToUdacityHQ] = String(minDistance)
        statistics [AppStatistics.nameMinDistanceToUdacityHQ] = minName
        statistics [AppStatistics.maxDistanceToUdacityHQ] = String(maxDistance)
        statistics [AppStatistics.nameMaxDistanceToUdacityHQ] = maxName
    
        return statistics
    }
    
}
