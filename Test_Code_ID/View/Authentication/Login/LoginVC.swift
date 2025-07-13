//
//  LoginVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var revealPassButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private let viewModel = LoginVM()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        handleUI()
    }
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == revealPassButton {
            Functions.securedField(textField: passwordTextField, sender: revealPassButton)
        }else if sender == registerButton {
            let registrationVC = RegistrationVC()
            navigationController?.pushViewController(registrationVC, animated: true)
        }
        
    }
    
    
    private func bindViewModel(){
        viewModel.authResult
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let user):
                    self?.showSuccessToast(message: "Login succeeded. Hi, \(user.name)")
                    self?.emailTextField.removeErrorBorder()
                    self?.passwordTextField.removeErrorBorder()
                    
                    let tabBarVC = TabBarVC()
                    self?.navigationController?.pushViewController(tabBarVC, animated: true)
                    
                case .failure(let error):
                    self?.showErrorToast(message: "\(error.localizedDescription)")
                    self?.emailTextField.showErrorBorder()
                    self?.passwordTextField.showErrorBorder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handleUI(){
        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        signInButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.loginUser()
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] in
                self?.emailTextField.removeErrorBorder()
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] in
                self?.passwordTextField.removeErrorBorder()
            })
            .disposed(by: disposeBag)
    }
    
    
}
