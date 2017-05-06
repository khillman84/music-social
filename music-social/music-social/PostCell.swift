//
//  PostCell.swift
//  music-social
//
//  Created by Kyle Hillman on 4/23/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

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
    
    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
    }
    
}
