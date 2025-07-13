//
//  RegistrationVM.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 12/07/25.
//

import RxSwift
import RxCocoa

class RegisterVM {
    let name = BehaviorRelay<String>(value: "")
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    let authResult = PublishRelay<Result<UserModel, Error>>()

    func registerUser() {
        if let _ = SQLiteManager.shared.getUserbyEmail(email: email.value) {
            authResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email is already registered"])))
            return
        }

        let newUser = UserModel(id: nil, name: name.value, email: email.value, password: password.value)

        if SQLiteManager.shared.insertUser(newUser) {
            if let savedUser = SQLiteManager.shared.getUserbyEmail(email: newUser.email) {
                CurrentUserManager.shared.setCurrentUser(savedUser)
                authResult.accept(.success(savedUser))
            } else {
                authResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user after registration"])))
            }
        } else {
            authResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Registration failed"])))
        }
    }
}
