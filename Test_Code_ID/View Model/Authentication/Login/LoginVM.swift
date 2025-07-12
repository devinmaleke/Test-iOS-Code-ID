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
        if let user = SQLiteManager.shared.getUserbyEmail(email: email.value) {
            CurrentUserManager.shared.setCurrentUser(user)
            authResult.accept(.success(user))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email atau password salah"])
            authResult.accept(.failure(error))
        }
    }
}
