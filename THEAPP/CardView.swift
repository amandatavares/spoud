//
//  CardView.swift
//  THEAPP
//
//  Created by Ada 2018 on 18/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class CardView: UIView {

    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0.5;
        self.layer.shadowOpacity = 0.2;
    }

}
