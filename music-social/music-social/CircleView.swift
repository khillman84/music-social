//
//  CircleView.swift
//  music-social
//
//  Created by Kyle Hillman on 4/23/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        
        //Turn FB button into circle once size has been determined
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
