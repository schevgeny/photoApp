//
//  AlertView.swift
//  photopicker
//
//  Created by Eugene sch on 8/24/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit

protocol AlertViewDelegate: AnyObject {
    func loadData()
}

class AlertView: UIView {
    
    var filePath = ""
    var num = 0
    weak var delegate: AlertViewDelegate?
    
    class func instanceFromNib() -> AlertView {
        return UINib(nibName: "AlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertView
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        _ = ImageManager.shared.deleteImage(at: num)
        delegate?.loadData()
        self.removeFromSuperview()
    }
    
}
