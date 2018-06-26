//
//  Response.swift
//  TodayApp
//
//  Created by Ada 2018 on 18/06/18.
//  Copyright © 2018 Academy 2018. All rights reserved.
//

import Foundation

struct Response: Codable {
    
    struct Student: Codable {
        
        let id: Int?
        let imageUrl: URL?
        let name: String?
        let university: String?
        let major: String?
        let area: String?
        let startDate: String?
        let job: String?
        let phone: String?
        let email: String?
        let password: String?
        let created_at: String?
        let updated_at: String?
        
    }

    let status : String
    let message : String
    let results : [Student]
    
}
