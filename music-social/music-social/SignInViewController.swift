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

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: FancyTextField!
    @IBOutlet weak var passwordField: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        })
    }

    @IBAction func signInPressed(_ sender: Any) {
        
        // Sign in with a users email and password through Firebase
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: password, password: email, completion: { (user, error) in
                if error == nil {
                    print("User authenticated with email")
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
}

