//
//  FancyButton.swift
//  music-social
//
//  Created by Kyle Hillman on 4/22/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class FancyButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set the shadow size and look
        layer.shadowColor = UIColor(red: gShadowGray, green: gShadowGray, blue: gShadowGray, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.cornerRadius = 2.0
        
    }


}
