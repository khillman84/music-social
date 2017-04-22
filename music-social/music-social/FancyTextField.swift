//
//  FancyTextField.swift
//  music-social
//
//  Created by Kyle Hillman on 4/22/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class FancyTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Custom border for text field
        layer.borderColor = UIColor(red: gShadowGray, green: gShadowGray, blue: gShadowGray, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }
    
    //Reset formatting of text fields
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
}
