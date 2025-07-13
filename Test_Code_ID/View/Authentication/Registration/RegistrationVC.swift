//
//  RegistrationVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var revealPassButton: UIButton!
    @IBOutlet weak var revealConfirmPassButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    private let viewModel = RegisterVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        handleUI()
        bindViewModel()
    }
    
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == revealPassButton {
            Functions.securedField(textField: passwordTextField, sender: revealPassButton)
        }else if sender == revealConfirmPassButton {
            Functions.securedField(textField: confirmPasswordTextField, sender: revealConfirmPassButton)
        }else if sender == backButton{
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupTextField() {
        [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0?.layer.cornerRadius = 6
            $0?.layer.borderWidth = 0
            $0?.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func resetTextFieldBorders() {
        [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0?.removeErrorBorder()
        }
    }
    
    private func handleUI() {
        continueButton.rx.tap
            .bind { [weak self] in
                self?.nameTextField.resignFirstResponder()
                self?.emailTextField.resignFirstResponder()
                self?.passwordTextField.resignFirstResponder()
                self?.confirmPasswordTextField.resignFirstResponder()
                self?.validateFields()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.authResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let user):
                    self?.showSuccessToast(message: "Registration succeeded, halo \(user.name)!")
                    
                    self?.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    self?.showErrorToast(message: error.localizedDescription)
                    self?.emailTextField.showErrorBorder()
                    self?.passwordTextField.showErrorBorder()
                    self?.nameTextField.showErrorBorder()
                    self?.confirmPasswordTextField.showErrorBorder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func validateFields() {
        resetTextFieldBorders()
        
        guard let name = nameTextField.text, !name.isEmpty else {
            showError(for: nameTextField, message: "Name cannot be empty")
            return
        }
        
        guard let email = emailTextField.text, email.isValidEmail else {
            showError(for: emailTextField, message: "Email not valid")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showError(for: passwordTextField, message: "Password cannot be empty")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
            showError(for: confirmPasswordTextField, message: "Password confirmation does not match")
            return
        }
        
        viewModel.name.accept(name)
        viewModel.email.accept(email)
        viewModel.password.accept(password)
        
        viewModel.registerUser()
    }
    
    private func showError(for textField: UITextField, message: String) {
        textField.showErrorBorder()
        showErrorToast(message: message)
    }
    
}
