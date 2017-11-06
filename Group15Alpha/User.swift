//
//  User.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 10/26/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import Foundation

var users:[User] = [User(email:"admin", password:"admin")]

class User {
    var email: String
    var password: String
    var name: String
    var record: Float
    var couponList: [String]
    var gender: String
    var major: String
    var year: Int
    var linkedAcc: [String]
    var createdDate: Calendar
    
    
    init(email:String,password:String) {
        self.email = email
        self.password = password
        self.name = ""
        self.record = 0;
        self.couponList = []
        self.gender = ""
        self.major = ""
        self.year = 0
        self.linkedAcc = []
        self.createdDate = NSCalendar.current
    }
    
    
    
}
