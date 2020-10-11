//
//  ViewController.swift
//  photopicker
//
//  Created by Eugene sch on 8/24/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit

enum ItemType: Int {
    case folder
    case image
}

class ViewController: UIViewController, AlertViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var navItem: UINavigationItem?
    @IBOutlet weak var backFolder: UIBarButtonItem?
    
    var dataSource: [URL]?
    var selectImageView:UIImageView?
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.loadData()
    }
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Folder", style: .default, handler: { action in
            
            let folder = UIAlertController(title: "Add folder", message: "Enter folder name", preferredStyle: .alert)
            
            folder.addTextField { (textField) in
                textField.placeholder = "folder name"
            }
            folder.addAction(UIAlertAction(title: "Save", style: .default, handler:{ action in
                if let name = folder.textFields?.first?.text {
                    self.addFolder(name: name)
                }
                
            }))
            
            folder.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(folder, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        ImageManager.shared.folderBack()
        loadData()
    }
    
    
    func loadData() {
        ImageManager.shared.loadData()
        self.collectionView?.reloadData()
        navItem?.title = ImageManager.shared.dataSource.title
        backFolder?.title = (ImageManager.shared.isRootFolder()) ? "" : "Back"
    }
    
    func addFolder(name: String) {
        ImageManager.shared.addFolder(name: name)
        self.collectionView?.reloadData()
    }
    
    
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        let id = UUID()
        let fileURL = documentsDirectory.appendingPathComponent(id.uuidString)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
            print(fileURL.path)
            ImageManager.shared.addImage(id: id)
            return id.uuidString
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
        
    }
    
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage{
            _ = self.saveImage(image: pickedImage)
            self.loadData()
            collectionView?.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch ItemType(rawValue: section) {
        case .folder:
            return ImageManager.shared.dataSource.subDir.count
        case .image:
            return ImageManager.shared.dataSource.images.count
        default: return 0
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch ItemType(rawValue: indexPath.section) {
        case .folder:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.className, for: indexPath) as? FolderCell else {
                return UICollectionViewCell()
            }
            cell.set(model: ImageManager.shared.dataSource.subDir[indexPath.item], delegate: self )
            
            return cell
        case .image:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.className, for: indexPath) as? ImageCell else {
                return UICollectionViewCell()
            }
            cell.set(mainView: self.view, num: indexPath.item, delegate: self )
            
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch ItemType(rawValue: indexPath.section) {
        case .folder:
            let folder = ImageManager.shared.dataSource.subDir[indexPath.row]
            ImageManager.shared.switchFolder(to: folder)
            loadData()
        default: return
        }
    }
}


