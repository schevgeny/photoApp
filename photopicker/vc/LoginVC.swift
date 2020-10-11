//
//  LoginVC.swift
//  photopicker
//
//  Created by Eugene sch on 8/25/20.
//  Copyright © 2020 Eugene sch. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginTextField: UITextField?
    @IBOutlet weak var passTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func loginAction(_ sender: UIButton) {
        guard let login = self.loginTextField?.text,
            let pass = self.passTextField?.text,
            let users = UserDefaults.standard.value([String: Users].self, forKey: "users"),
            let user = users[login]
            else { return }
        
        if user.pass == pass {
            guard let stb = self.storyboard,
                let vc = stb.instantiateViewController(identifier: ViewController.className) as? ViewController else { return }
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "error", message: "auth faild", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil ))
            self.present(alert, animated: false)
        }
    }
    
    @IBAction func regAction(_ sender: UIButton) {
        guard let stb = self.storyboard, let vc = stb.instantiateViewController(identifier: RegVC.className) as? RegVC else {return}
        self.present(vc, animated: true, completion: nil)
    }
    

}


extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
