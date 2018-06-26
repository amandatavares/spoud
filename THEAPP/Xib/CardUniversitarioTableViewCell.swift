//
//  CardUniversitarioTableViewCell.swift
//  THEAPP
//
//  Created by Ada 2018 on 14/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class CardUniversitarioTableViewCell: UITableViewCell {

    @IBOutlet weak var viewAzul: UIView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var universidadeLabel: UILabel!
    @IBOutlet weak var cursoLabel: UILabel!
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        fotoImageView.layer.cornerRadius = 30
        fotoImageView.clipsToBounds = true
        
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowRadius = 0.5;
        cardView.layer.shadowOpacity = 0.2;
        
        viewAzul.layer.cornerRadius = 5
        viewAzul.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        viewAzul.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        if selected {
            let color = cardView.backgroundColor
            
            cardView.backgroundColor = #colorLiteral(red: 0.8048484622, green: 0.8128172589, blue: 0.8128172589, alpha: 1)
            
            super.setSelected(selected, animated: animated)
        } else{
            cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            viewAzul.backgroundColor = #colorLiteral(red: 0.007234328426, green: 0.5179384351, blue: 0.8449995518, alpha: 1)
        }
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        if highlighted {
            let color = cardView.backgroundColor
            
            super.setHighlighted(highlighted, animated: animated)
            
            cardView.backgroundColor = #colorLiteral(red: 0.792083691, green: 0.792083691, blue: 0.792083691, alpha: 1)
        } else {
            cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            viewAzul.backgroundColor = #colorLiteral(red: 0.007234328426, green: 0.5179384351, blue: 0.8449995518, alpha: 1)
        }
        
    }
    
}
