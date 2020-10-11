//
//  User.swift
//  photopicker
//
//  Created by Eugene sch on 8/25/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import Foundation

class Users: Codable {
    
    var login: String?
    var pass: String?
    
    private enum CodingKeys: String, CodingKey {
        case login
        case pass
    }
    
    init(login: String, pass: String){
        self.login = login
        self.pass = pass
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        login = try container.decode(String.self, forKey: .login)
        pass = try container.decodeIfPresent(String.self, forKey: .pass)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.login, forKey: .login)
        try container.encode(self.pass, forKey: .pass)
    }

}
