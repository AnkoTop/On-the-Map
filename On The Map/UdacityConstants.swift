//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import Foundation
import CoreLocation

extension UdacityClient {
    
    struct Constants {
        static let baseSecureURL = "https://www.udacity.com/"
        static let location = CLLocation(latitude: 37.400104,longitude: -122.108285)
    }
    
    struct Methods {
        static let signUp = "account/auth#!/signup"
        static let signIn = "api/session"
        static let getUserData = "api/users/"
    }
    
    struct JSONBodyKeys {
        static let udacity = "udacity"
        static let userName = "username"
        static let passWord = "password"
        //for facebook login
        static let facebook = "facebook_mobile"
        static let token = "access_token"
    }
    
    struct JSONResponseKeys {
        //account
        static let account = "account"
        // user
        static let isRegistered = "registered"
        static let userID = "key"
        // session
        static let session = "session"
        static let sessionID = "id"
        static let sessionExpiration = "expiration"
        //status
        static let statusCode = "status"
        static let errorMessage = "error"
        //userdata
        static let user = "user"
        static let lastName = "last_name"
        static let firstName = "first_name"
    }
}
