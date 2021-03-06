//
//  ParseConstants.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import Foundation

extension  ParseClient {
    
    struct Constants {
        static let baseSecureURL = "https://api.parse.com/1/classes/StudentLocation"
        static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
     }

    struct Methods {
        static let limitResults = "?limit="
        static let limit = 100
        static let skip = 100
        static let skipResults = "&skip="
        static let searchOnUserPart1 = "?where=%7B%22uniqueKey%22%3A%22"
        static let searchOnUserPart2 = "%22%7D"
    }
    
    struct JSONBodyKeys {
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    struct JSONResponseKeys {
        static let errorMessage = "error"
        static let results = "results"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
    
}
