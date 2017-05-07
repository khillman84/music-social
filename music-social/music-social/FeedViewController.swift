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
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: FancyTextField!

    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true 
        imagePicker.delegate = self
       
        // Retrieve data from Firebase database
        DataService.dataService.ref_posts.observe(.value, with: { (snapshot) in
            
            self.posts = [] //reset view so no duplicates show up
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
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
            imageSelected = true
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
    
    @IBAction func postButtonPressed(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print ("Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print ("Image must be added")
            return
        }
        
        // Uploading data to Firebase
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.dataService.ref_post_images.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print ("Unable to upload image to Firebase storage")
                } else {
                    print ("Successfully loaded image to Firebase storage")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, Any> = [
            "caption" : captionField.text ?? "",
            "imageUrl": imgUrl,
            "likes"   : 0,
            "date"    : "\(Date())"
        ]
        
        let firebasePost = DataService.dataService.ref_posts.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
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
            
            posts.sort(by: {$0.date > $1.date})
            
            // Grab the image from the cache or download them from Firebase
            if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
     }
    
}




















