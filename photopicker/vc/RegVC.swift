//
//  RegVC.swift
//  photopicker
//
//  Created by Eugene sch on 8/25/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit
import SwiftyKeychainKit

class RegVC: UIViewController {

    private let keychain = Keychain(service: "com.swifty.keychain")
    
    @IBOutlet weak var passTextField: UITextField?
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let pass = self.passTextField?.text  else { return }
       
        try? self.keychain.set(pass, for: .password)
        ImageManager.shared.reset()
        self.dismiss(animated: true, completion: nil)
    }
}

extension KeychainKeys {
    static let password = KeychainKey<String>(key: "password")
}
