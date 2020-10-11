//
//  StorageManager.swift
//  photopicker
//
//  Created by Eugene sch on 8/26/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import Foundation
import UIKit

class StorageManager {
    
    enum Keys: String {
        case textKey = "textKey"
    }
    
    static let shared = StorageManager()
    private init() {}
    
    func save(text: String) {
        UserDefaults.standard.set(text, forKey: Keys.textKey.rawValue)
    }
    
    func load() -> String? {
        guard let text = UserDefaults.standard.value(forKey: Keys.textKey.rawValue) as? String else { return nil }
        
        return text
    }
    
    func incrementStartCount() {
        guard let count = UserDefaults.standard.value(forKey: "count") as? Int else { return }
        UserDefaults.standard.set(count+1, forKey: "count")
    }
    
    func getImageList() -> [UUID: ImageInfo] {
        return UserDefaults.standard.value([UUID: ImageInfo].self, forKey: "images") ?? [UUID: ImageInfo]()
    }
}



func loadSave(fileName:String) -> UIImage? {
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    
    if let dirPath = paths.first {
        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image
        
    }
    return nil
}
