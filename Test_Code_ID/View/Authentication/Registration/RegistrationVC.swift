//
//  RegistrationVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit

class RegistrationVC: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var revealPassButton: UIButton!
    @IBOutlet weak var revealConfirmPassButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    

    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == revealPassButton {
            Functions.securedField(textField: passwordTextField, sender: revealPassButton)
        }else if sender == revealConfirmPassButton {
            Functions.securedField(textField: confirmPasswordTextField, sender: revealConfirmPassButton)
        }else if sender == continueButton {
            navigationController?.popViewController(animated: true)
        }else if sender == backButton{
            navigationController?.popViewController(animated: true)
        }
    }
    
}
