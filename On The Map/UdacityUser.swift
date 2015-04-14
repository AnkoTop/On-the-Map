//
//  UdacityUser.swift
//  On The Map
//
//  Created by Anko Top on 11/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import Foundation

// create a global accesible udacityuser (singleton)
let udacityUser = UdacityUser()

final class UdacityUser {
    
    var firstName: String = ""
    var lastName: String = ""
    var userId: String = ""
    var hasStudentLocation: Bool?
    var objectIdStudentLocation = ""
    
    private init() {}
    
    
    func setDataUdacityUser(firstName: String, lastName: String, userId: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userId = userId
    }
    
    func setStudentLocation(hasStudentLocation: Bool, objectId: String) {
        self.hasStudentLocation = hasStudentLocation
        self.objectIdStudentLocation = objectId
    }
}