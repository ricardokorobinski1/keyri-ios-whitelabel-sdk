//
//  UserService.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 02.11.2021.
//

import Foundation

final class UserService {
    static let shared = UserService()
    private init() {}
    
//    func mobileLogin(account: PublicAccount,
//                     service: Service,
//                     callbackUrl: URL,
//                     custom: String?, extendedHeaders: [String: String]? = nil, completion: @escaping (Result<[String: Any], Error>) -> Void) {
//        guard
//            let sessionAccount = StorageService.shared.getAllAccounts(serviceId: service.id).first(where: { $0.username == account.username })
//        else {
//            print("no account found")
//            completion(.failure(KeyriErrors.accountNotFound))
//            return
//        }
//
//        let encUserId = sessionAccount.userId
//
//        let box = KeychainService.shared.getCryptoBox()
//        let userIdData = AES.decryptionAESModeECB(messageData: encUserId.data(using: .utf8)!, key: box.privateKey)!
//        let userId = String(data: userIdData, encoding: .utf8)!
//
//        ApiService.shared.authMobile(url: callbackUrl, userId: userId, username: sessionAccount.username, clientPublicKey: box.publicKey, extendedHeaders: extendedHeaders, completion: completion)
//    }
    
//    func mobileSignUp(username: String, service: Service, callbackUrl: URL, custom: String?, extendedHeaders: [String: String]? = nil, completion: @escaping (Result<[String: Any], Error>) -> Void) {
//        guard let account = createUser(username: username, service: service, custom: custom).account else {
//            assertionFailure(KeyriErrors.accountCreationFails.errorDescription ?? "")
//            completion(.failure(KeyriErrors.accountCreationFails))
//            return
//        }
//        let box = KeychainService.shared.getCryptoBox()
//        let userIdData = AES.decryptionAESModeECB(messageData: account.userId.data(using: .utf8)!, key: box.privateKey)!
//        let userId = String(data: userIdData, encoding: .utf8)!
//        
//        ApiService.shared.authMobile(url: callbackUrl, userId: userId, username: username, clientPublicKey: box.publicKey, extendedHeaders: extendedHeaders, completion: completion)
//    }
}
