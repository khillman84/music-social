//
//  FeedViewController.swift
//  music-social
//
//  Created by Kyle Hillman on 4/23/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var posts = [Post]()
    @IBOutlet weak var imageAdd: CircleView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true 
        imagePicker.delegate = self
       
        // Retrieve data from Firebase database
        DataService.dataService.ref_posts.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
        } else {
            print("A valid image was not selected")
        }

        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func signOutPressed(_ sender: Any) {
        
        // Remove UID and sign out of Firebase
        KeychainWrapper.standard.removeObject(forKey: gKeyUID)
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension FeedViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
     }
    
}
