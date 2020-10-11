//
//  imageCell.swift
//  photopicker
//
//  Created by Eugene sch on 8/26/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var mainView: UIView?
    var num = 0
    var delegate: AlertViewDelegate?
    
    func set(mainView: UIView, num: Int, delegate: AlertViewDelegate){
        
        self.mainView = mainView
        self.num = num
        self.delegate = delegate
        
        imageView.image = ImageManager.shared.getImage(num: self.num)
 
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(deletePopup))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        let tapView = UITapGestureRecognizer(target: self, action: #selector(open))
        imageView.addGestureRecognizer(tapView)
    }
    
    @objc func deletePopup(sender: UITapGestureRecognizer){
        if (sender.state == .began) {
            let xib = AlertView.instanceFromNib()
            xib.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
            xib.center = self.mainView?.center ?? CGPoint()
            xib.filePath = ImageManager.shared.getPath(by: self.num)
            xib.delegate = self.delegate
            self.mainView?.addSubview(xib)
        }
    }
    
    @objc func open(sender: UITapGestureRecognizer){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: ViewVC.className) as? ViewVC else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.set(num: self.num)
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
}
