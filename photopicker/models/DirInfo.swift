//
//  DirInfo.swift
//  photopicker
//
//  Created by Eugene sch on 9/20/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import Foundation


class DirInfo: Codable {
    var title = ""
    var id = UUID()
    var subDir: [DirInfo] = []
    var images: [ImageInfo] = []
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case subDir
        case images
    }
    
    init(title: String){
        self.title = title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subDir = try container.decode([DirInfo].self, forKey: .subDir)
        images = try container.decode([ImageInfo].self, forKey: .images)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.subDir, forKey: .subDir)
        try container.encode(self.images, forKey: .images)
    }
    
}
