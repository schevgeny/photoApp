//
//  ImageManager.swift
//  photopicker
//
//  Created by Eugene sch on 8/30/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import Foundation
import UIKit
class ImageManager {
    
    static let shared = ImageManager()
    
    private init() {}
    
    var dataSource = DirInfo(title: "root")
    private var folderTree:[DirInfo] = []
    
    func loadData() {
        if dataSource.title == "root" {
            self.dataSource = UserDefaults.standard.value(DirInfo.self, forKey: "images") ?? DirInfo(title: "root")
        }
    }
    
    func addImage(id: UUID){
        let image = ImageInfo(id: id)
        self.dataSource.images.append(image)
        self.save()
    }
    
    func addFolder(name: String){
        self.dataSource.subDir.append(DirInfo(title: name))
        self.save()
    }
    
    func switchFolder(to folder: DirInfo){
        self.folderTree.append(self.dataSource)
        self.dataSource = folder
    }
    
    func folderBack(){
        self.dataSource = folderTree.removeLast()
    }
    
    func isRootFolder() -> Bool {
        return (folderTree.count == 0) ? true : false
    }
    
    func deleteImage(at num: Int) -> Bool {
        let fileManager = FileManager.default
        let path = getPath(by: num)
        do {
            if fileManager.fileExists(atPath: path) {
                try fileManager.removeItem(atPath: path)
                
                _ = self.deleteImage(at: num)
                self.dataSource.images.remove(at: num)
                self.save()
                return true
            }
        }catch let error as NSError {
            print("An error took place: \(error)")
        }
        
        return false
    }
    
    func count() -> Int {
        return dataSource.images.count +  dataSource.subDir.count
    }
    
    func getImage(num: Int) -> UIImage {
        guard let fileURL = self.dataSource.images[num].getUrl() else { return UIImage() }
        return UIImage(contentsOfFile: fileURL.path) ?? UIImage()
    }
    
    func getPath(by num: Int) -> String {
        guard let imageUrl = ImageManager.shared.dataSource.images[num].getUrl() else {return ""}
        return imageUrl.path
    }
    
    func getLastPathComponent(by num: Int) -> String {
        guard let imageUrl = ImageManager.shared.dataSource.images[num].getUrl() else {return ""}
        return imageUrl.lastPathComponent
    }
    
    private func save(){
        if self.isRootFolder() {
            UserDefaults.standard.set(encodable: self.dataSource, forKey: "images")
        } else {
            UserDefaults.standard.set(encodable: self.folderTree.first, forKey: "images")
        }
        
    }
    
}
