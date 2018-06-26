//
//  MyTextField.swift
//  THEAPP
//
//  Created by Ada 2018 on 18/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class MyTextField: UITextField {

    override func draw(_ rect: CGRect) {
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
 

}
