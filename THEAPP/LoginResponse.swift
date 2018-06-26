//
//  LoginResponse.swift
//  THEAPP
//
//  Created by Ada 2018 on 22/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    var status: Int
    var token: String
    var student : Universitario
}
