//
//  UserModel.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 12/07/25.
//

import Foundation

struct UserModel: Codable {
    let id: Int?
    let name: String
    let email: String
    let password: String
}
