//
//  DataService.swift
//  music-social
//
//  Created by Kyle Hillman on 4/24/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

// Store the Firebase reference URL stored in the GoogleService-Info.plist
let gDataBase = FIRDatabase.database().reference()
let gStorageBase = FIRStorage.storage().reference()

class DataService {
    
    static let dataService = DataService()
    
    // Database References
    private var _ref_base = gDataBase
    private var _ref_posts = gDataBase.child("posts")
    private var _ref_users = gDataBase.child("users")
    
    // Storage References
    private var _ref_post_images = gStorageBase.child("post-pics")
    private var _ref_profile_images = gStorageBase.child("profile-pics")
    
    var ref_base: FIRDatabaseReference {
        return _ref_base
    }
    
    var ref_posts: FIRDatabaseReference {
        return _ref_posts
    }
    
    var ref_users: FIRDatabaseReference {
        return _ref_users
    }
    
    var ref_post_images: FIRStorageReference {
        return _ref_post_images
    }
    
    var ref_profile_images: FIRStorageReference {
        return _ref_profile_images
    }
    
    var ref_user_current: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: gKeyUID)
        let user = ref_users.child(uid!)
        return user
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        ref_users.child(uid).updateChildValues(userData)
    }
    
}
