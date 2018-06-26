//
//  Header.swift
//  THEAPP
//
//  Created by Ada 2018 on 19/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class Header: UITableViewHeaderFooterView {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterBtn: UIButton!
    
    var delegate: HeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchBar.backgroundImage = UIImage()
        
        filterBtn.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
    }
    @objc func filterTapped(){
        self.delegate?.filterTapped()
    }
}


