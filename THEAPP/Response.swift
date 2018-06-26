//
//  Response.swift
//  THEAPP
//
//  Created by Ada 2018 on 20/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

struct Response : Codable {
    var status : String
    var message : String
    var data : [Universitario]
    
}
