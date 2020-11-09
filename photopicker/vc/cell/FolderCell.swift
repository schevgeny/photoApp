//
//  FolderCell.swift
//  photopicker
//
//  Created by Eugene sch on 9/14/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit

class FolderCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var delegate: AlertViewDelegate?
    var model: DirInfo?
    
    func set(model: DirInfo, delegate: AlertViewDelegate){
        self.delegate = delegate
        self.model = model
        
        nameLabel?.text = model.title
        
        widthConstraint.constant = (UIScreen.main.bounds.width - 8 * 6) / 3 - 4
    }
}
