//
//  PostCell.swift
//  music-social
//
//  Created by Kyle Hillman on 4/23/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post : Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
        // Check if image is stored, download it if not
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print ("Unable to download image from Firebase storage")
                } else {
                    print ("Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedViewController.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
    
}
