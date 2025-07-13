//
//  EditProfileVM.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 12/07/25.
//

import Foundation
import RxSwift
import RxCocoa

class EditProfileVM{
    let name = BehaviorRelay<String>(value: "")
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let confirmPassword = BehaviorRelay<String>(value: "")
    
    let updateResult = PublishRelay<Result<String, Error>>()
    let didUpdateProfile = PublishRelay<Void>()

    func loadCurrentUser() {
        guard let currentUser = CurrentUserManager.shared.currentUser else {
            return
        }
        name.accept(currentUser.name)
        email.accept(currentUser.email)
        password.accept(currentUser.password)
        confirmPassword.accept(currentUser.password)
    }
    
    func updateProfile() {
        let trimmedName = name.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty,
              !trimmedEmail.isEmpty,
              !trimmedPassword.isEmpty,
              !trimmedConfirmPassword.isEmpty else {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Every field must be filled in"])))
            return
        }

        guard trimmedPassword == trimmedConfirmPassword else {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password confirmation does not match"])))
            return
        }

        guard let currentUser = CurrentUserManager.shared.currentUser else {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            return
        }

        if trimmedName == currentUser.name && trimmedPassword == currentUser.password {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nothing was updated"])))
            return
        }

        let success = SQLiteManager.shared.updateUser(
            name: trimmedName,
            password: trimmedPassword,
            email: trimmedEmail
        )

        if success {
            if let updatedUser = SQLiteManager.shared.getUserbyEmail(email: trimmedEmail) {
                CurrentUserManager.shared.setCurrentUser(updatedUser)
                didUpdateProfile.accept(())
                updateResult.accept(.success("Profile updated successfully"))
            } else {
                updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load data after update"])))
            }
        } else {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Profile update failed"])))
        }
    }
}

