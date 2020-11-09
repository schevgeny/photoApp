//
//  LoginVC.swift
//  photopicker
//
//  Created by Eugene sch on 8/25/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit
import SwiftyKeychainKit

class LoginVC: UIViewController {

    @IBOutlet weak var passTextField: UITextField?
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        guard let pass = self.passTextField?.text
            else { return }
       
        let keychain = Keychain(service: "com.swifty.keychain")
        let userPassword = try? keychain.get(.password)
    
        if userPassword == pass {
            guard let stb = self.storyboard,
                let vc = stb.instantiateViewController(identifier: ViewController.className) as? ViewController else { return }
            
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "error", message: "auth faild", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil ))
            self.present(alert, animated: false)
        }
    }
    
    @IBAction func regAction(_ sender: UIButton) {
        guard let stb = self.storyboard,
              let vc = stb.instantiateViewController(identifier: RegVC.className) as? RegVC else {return}
        self.present(vc, animated: true, completion: nil)
    }
    
    
    

}


extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
