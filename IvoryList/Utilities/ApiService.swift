//
//  ApiService.swift
//  IvoryList
//
//  Created by atomic on 02.11.2021.
//

import Foundation

final class ApiService {
    static let shared = ApiService()
    
    enum Permissions: String {
        case getSession
        case signUp
        case login
        case mobileLogin
        case mobileSignUp
        case accounts
    }
}
