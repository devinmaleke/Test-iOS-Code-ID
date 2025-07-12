//
//  EditProfileVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var revealPassButton: UIButton!
    @IBOutlet weak var revealConfirmPassButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    private let viewModel = LoginVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == backButton{
            navigationController?.popViewController(animated: true)
        }else if sender == revealPassButton{
            Functions.securedField(textField: passwordTF, sender: revealPassButton)
        }else if sender == revealConfirmPassButton{
            Functions.securedField(textField: confirmPasswordTF, sender: revealConfirmPassButton)
        }else if sender == confirmButton{
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func initUI(){
        if let currentUser = CurrentUserManager.shared.currentUser {
            nameTF.text = currentUser.name
            emailTF.text = currentUser.email
            passwordTF.text = currentUser.password
            confirmPasswordTF.text = currentUser.password
        }
    }
    
}
