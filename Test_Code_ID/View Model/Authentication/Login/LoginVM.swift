//
//  LoginVM.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 12/07/25.
//

import Foundation
import RxSwift
import RxCocoa

class LoginVM{
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    let authResult = PublishRelay<Result<UserModel, Error>>()

    func loginUser() {
        guard !email.value.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.value.trimmingCharacters(in: .whitespaces).isEmpty else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email dan password wajib diisi."])
            authResult.accept(.failure(error))
            return
        }

        if let user = SQLiteManager.shared.getUserbyEmail(email: email.value) {
            if user.password == password.value {
                CurrentUserManager.shared.setCurrentUser(user)
                authResult.accept(.success(user))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email atau password salah."])
                authResult.accept(.failure(error))
            }
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email atau password salah."])
            authResult.accept(.failure(error))
        }
    }}
