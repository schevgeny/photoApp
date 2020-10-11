//
//  AddCell.swift
//  photopicker
//
//  Created by Eugene sch on 8/26/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit

class AddCell: UICollectionViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    
    var imagePicker: UIImagePickerController?
    
    @IBAction func addAction(_ sender: UIButton) {
        guard let imagePicker = self.imagePicker else { return }

        imagePicker.sourceType = .photoLibrary
        self.window?.rootViewController?.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
}
