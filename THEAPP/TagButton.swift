//
//  TagButton.swift
//  THEAPP
//
//  Created by Ada 2018 on 25/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

@IBDesignable
class TagButton: UIButton {
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.tintColor = .white
                self.backgroundColor = #colorLiteral(red: 0.007234328426, green: 0.5179384351, blue: 0.8449995518, alpha: 1)
                self.layer.cornerRadius = 5
                self.layer.borderWidth = 0
            } else {
                self.tintColor = #colorLiteral(red: 0.007234328426, green: 0.5179384351, blue: 0.8449995518, alpha: 1)
                self.backgroundColor = .clear
                self.layer.cornerRadius = 5
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.007234328426, green: 0.5179384351, blue: 0.8449995518, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
