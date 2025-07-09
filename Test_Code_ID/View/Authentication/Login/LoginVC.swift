//
//  LoginVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var revealPassButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == signInButton {
            self.navigationController?.pushViewController(TabBarVC(), animated: true)
        }else if sender == revealPassButton {
            Functions.securedField(textField: passwordTextField, sender: revealPassButton)
        }else if sender == registerButton {
            let registrationVC = RegistrationVC()
            navigationController?.pushViewController(registrationVC, animated: true)
        }
        
    }
    
    
    
    
}
