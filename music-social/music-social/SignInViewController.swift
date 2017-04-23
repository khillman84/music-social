//
//  ViewController.swift
//  music-social
//
//  Created by Kyle Hillman on 4/22/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: FancyTextField!
    @IBOutlet weak var passwordField: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Check if there is a UID, then perform segue
        if let _ = KeychainWrapper.standard.string(forKey: gKeyUID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func fbButtonPressed(_ sender: Any) {
        
        // Authenticate users Facebook credentials
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to login into Facebook")
            } else if result?.isCancelled == true {
                print("User cancelled Facebook authorization")
            } else {
                print("Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthentication(credential)
            }
        }
        
    }
    
    // Pass in Facebook credential to authenticate with Firebase
    func firebaseAuthentication(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to login with Firebase")
            } else {
                print("Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }

    @IBAction func signInPressed(_ sender: Any) {
        
        // Sign in with a users email and password through Firebase
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: password, password: email, completion: { (user, error) in
                if error == nil {
                    print("User authenticated with email")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with Firebase using email")
                        } else {
                            print("Successfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
    }
    
    // Set the user login info into the keychain wrapper
    func completeSignIn(id: String) {
        KeychainWrapper.standard.set(id, forKey: gKeyUID)
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

