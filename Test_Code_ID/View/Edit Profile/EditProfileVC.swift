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
    
    private let viewModel = EditProfileVM()
    var didUpdate: PublishRelay<Void> {
        return viewModel.didUpdateProfile
    }
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.loadCurrentUser()
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == backButton{
            navigationController?.popViewController(animated: true)
        }else if sender == revealPassButton{
            Functions.securedField(textField: passwordTF, sender: revealPassButton)
        }else if sender == revealConfirmPassButton{
            Functions.securedField(textField: confirmPasswordTF, sender: revealConfirmPassButton)
        }else if sender == confirmButton{
            viewModel.updateProfile()
        }
    }
    
    private func bindViewModel() {
        nameTF.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: disposeBag)
        emailTF.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTF.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        confirmPasswordTF.rx.text.orEmpty.bind(to: viewModel.confirmPassword).disposed(by: disposeBag)
        
        viewModel.name.bind(to: nameTF.rx.text).disposed(by: disposeBag)
        viewModel.email.bind(to: emailTF.rx.text).disposed(by: disposeBag)
        viewModel.password.bind(to: passwordTF.rx.text).disposed(by: disposeBag)
        viewModel.confirmPassword.bind(to: confirmPasswordTF.rx.text).disposed(by: disposeBag)
        
        viewModel.updateResult.subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let message):
                self?.showSuccessToast(message: message)
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self?.showErrorToast(message: error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
}
