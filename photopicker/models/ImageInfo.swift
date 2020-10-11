//
//  ImageInfo.swift
//  photopicker
//
//  Created by Eugene sch on 8/30/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import Foundation

class ImageInfo: Codable {
    var id: UUID?
    var like = false
    var comment = ""
    
    private enum CodingKeys: String, CodingKey {
        case id
        case like
        case comment
    }
    
    init(){
        self.like = false
        self.comment = ""
    }
    
    init(like: Bool, comment: String){
        self.like = like
        self.comment = comment
    }
    
    init(id: UUID){
        self.id = id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        like = try container.decode(Bool.self, forKey: .like)
        comment = try container.decode(String.self, forKey: .comment)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.like, forKey: .like)
        try container.encode(self.comment, forKey: .comment)
    }
    
    func getUrl() -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentsDirectory.appendingPathComponent(self.id?.uuidString ?? "")
    }
    
}
