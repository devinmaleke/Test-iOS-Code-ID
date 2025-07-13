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
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Semua field wajib diisi."])))
            return
        }

        guard trimmedPassword == trimmedConfirmPassword else {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password dan konfirmasi tidak cocok."])))
            return
        }

        guard let currentUser = CurrentUserManager.shared.currentUser else {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User tidak ditemukan."])))
            return
        }

        if trimmedName == currentUser.name && trimmedPassword == currentUser.password {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Tidak ada data yang diubah."])))
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
                updateResult.accept(.success("Profil berhasil diperbarui."))
            } else {
                updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal memuat data setelah update."])))
            }
        } else {
            updateResult.accept(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal memperbarui profil."])))
        }
    }
}

