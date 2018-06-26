//
//  PostResponse.swift
//  THEAPP
//
//  Created by Ada 2018 on 21/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

struct PostResponse: Codable {
    var status: String
    var message: String
    var data: Universitario
}
