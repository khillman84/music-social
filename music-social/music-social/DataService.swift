//
//  DataService.swift
//  music-social
//
//  Created by Kyle Hillman on 4/24/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import Foundation
import Firebase

// Store the Firebase reference URL stored in the GoogleService-Info.plist
let gDataBase = FIRDatabase.database().reference()

class DataService {
    
    static let dataService = DataService()
    
    private var _ref_base = gDataBase
    private var _ref_posts = gDataBase.child("posts")
    private var _ref_users = gDataBase.child("users")
    
    var ref_base: FIRDatabaseReference {
        return _ref_base
    }
    
    var ref_posts: FIRDatabaseReference {
        return _ref_posts
    }
    
    var ref_users: FIRDatabaseReference {
        return _ref_users
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        ref_users.child(uid).updateChildValues(userData)
    }
    
}
