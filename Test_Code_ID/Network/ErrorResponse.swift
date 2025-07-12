//
//  ErrorResponse.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import Foundation

enum NetworkError: Error {
    case decodingError(Error)
    case apiError(String)
    case urlError(URLError)
    case unknown(statusCode: Int, error: Error)
}

struct ErrorResponse: Decodable {
    let message: String
}
