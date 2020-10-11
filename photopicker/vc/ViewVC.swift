//
//  ViewVC.swift
//  photopicker
//
//  Created by Eugene sch on 8/26/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit

class ViewVC: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var likeButton: UIButton?
    @IBOutlet weak var mainImage: UIImageView?
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var filePath = ""
    var num = 0
    var imageInfo: ImageInfo?
    var imageInfoList = [String: ImageInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainImage?.image = ImageManager.shared.getImage(num: num)
        //self.closeButton?.layer.cornerRadius = closeButton?.frame.size.height ?? 0 / 2
        
        self.registerForKeyboardNotifications()
        
        loadInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let recognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftAction))
        recognizerLeft.direction = .right
        self.view.addGestureRecognizer(recognizerLeft)
        
        let recognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(rightAction))
        recognizerRight.direction = .left
        self.view.addGestureRecognizer(recognizerRight)
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func set(num: Int){
        self.num = num
    }
    
    private func getInfoKey() -> String {
        return "imageInfo_" + ImageManager.shared.getLastPathComponent(by: num)
    }
    
    func loadInfo(){
        imageInfoList = UserDefaults.standard.value([String: ImageInfo].self, forKey: "image_info") ?? [String: ImageInfo]()
        imageInfo = imageInfoList[getInfoKey()]
        
        if imageInfo == nil {
            imageInfo = ImageInfo()
        }
        
        likeButton?.isSelected = imageInfo?.like ?? false
        commentField?.text = imageInfo?.comment
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        //        if bottomConstraint.constant > 0 { return }
        
        let userInfo = notification.userInfo!
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        } else {
            bottomConstraint.constant = keyboardScreenEndFrame.height
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        likeButton?.isSelected = !(likeButton?.isSelected ?? false)
        guard let isLike = likeButton?.isSelected else { return }
        
        imageInfo?.like = isLike
        imageInfoList[getInfoKey()] = imageInfo
        UserDefaults.standard.set(encodable: imageInfoList, forKey: "image_info")
        
    }
    
    //MARK: second task
    @objc func leftAction(gesture: UISwipeGestureRecognizer) {
        if num  == 0 {
            num = ImageManager.shared.count()
        }
        num -= 1
        
        showImage(shift: -view.frame.size.width)
    }
    
    @objc func rightAction(gesture: UISwipeGestureRecognizer) {
        num += 1
        if num == ImageManager.shared.count() {
            num = 0
        }
        showImage(shift: view.frame.size.width)
    }
    
    func showImage(shift: CGFloat){
        guard let image = self.mainImage else { return }
        
        
        let newView = UIImageView()
        newView.image = ImageManager.shared.getImage(num: self.num)
        newView.frame = image.frame
        newView.frame.origin.x += shift
        newView.contentMode = image.contentMode
        newView.backgroundColor = .white
        
        view.addSubview(newView)
        
        UIView.animate(withDuration: 1, animations: {
            newView.frame = image.frame
        },completion: { (_) in
            image.image = newView.image
            self.loadInfo()
            newView.removeFromSuperview()
        })
    }
    
}

extension ViewVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.imageInfo?.comment = textField.text ?? ""
        imageInfoList[getInfoKey()] = self.imageInfo
        
        UserDefaults.standard.set(encodable: imageInfoList, forKey: "image_info")
        
        return true
    }
}
