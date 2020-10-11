//
//  UIView+ext.swift
//  photopicker
//
//  Created by Eugene sch on 8/25/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, cancelTitle: String? = "cancel", handler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet )
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: handler ))
        self.present(alert, animated: false)
    }
}
