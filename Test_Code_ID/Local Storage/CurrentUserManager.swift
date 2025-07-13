//
//  CurrentUserManager.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 12/07/25.
//

import Foundation

class CurrentUserManager {
    static let shared = CurrentUserManager()
    private init() {}
    
    private(set) var currentUser: UserModel?
    
    func setCurrentUser(_ user: UserModel?) {
        self.currentUser = user
    }
}
