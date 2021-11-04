//
//  UserService.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 02.11.2021.
//

import UIKit

final class UserService {
    static let shared = UserService()
    private init() {}
    
    func mobileLogin(account: PublicAccount,
                     service: Service,
                     callbackUrl: URL,
                     custom: String?, extendedHeaders: [String: String]? = nil, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard
            let sessionAccount = StorageService.shared.getAllAccounts(serviceId: service.id).first(where: { $0.username == account.username })
        else {
            print("no account found")
            completion(.failure(KeyriErrors.accountNotFound))
            return
        }

        let encUserId = sessionAccount.userId

        let box = KeychainService.shared.getCryptoBox()
        let userIdData = AES.decryptionAESModeECB(messageData: encUserId.data(using: .utf8)!, key: box.privateKey)!
        let userId = String(data: userIdData, encoding: .utf8)!

        ApiService.shared.authMobile(url: callbackUrl, userId: userId, username: sessionAccount.username, clientPublicKey: box.publicKey, extendedHeaders: extendedHeaders, completion: completion)
    }
    
    func mobileSignUp(username: String,
                      service: Service,
                      callbackUrl: URL,
                      custom: String?,
                      extendedHeaders: [String: String]? = nil,
                      completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let account = createUser(username: username,
                                       service: service,
                                       custom: custom).account else {
            assertionFailure(KeyriErrors.accountCreationFails.errorDescription ?? "")
            completion(.failure(KeyriErrors.accountCreationFails))
            return
        }
        let box = KeychainService.shared.getCryptoBox()
        let userIdData = AES.decryptionAESModeECB(messageData: account.userId.data(using: .utf8)!,
                                                  key: box.privateKey)!
        let userId = String(data: userIdData, encoding: .utf8)!
        
        ApiService.shared.authMobile(url: callbackUrl,
                                     userId: userId,
                                     username: username,
                                     clientPublicKey: box.publicKey,
                                     extendedHeaders: extendedHeaders,
                                     completion: completion)
    }
    
    func signUp(username: String, sessionId: String, service: Service, rpPublicKey: String?, custom: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let encUserId = createUser(username: username, service: service, custom: custom).encUserId else {
            assertionFailure(KeyriErrors.accountCreationFails.errorDescription ?? "")
            completion(.failure(KeyriErrors.accountCreationFails))
            return
        }
        SessionService.shared.verifyUserSession(encUserId: encUserId, sessionId: sessionId, rpPublicKey: rpPublicKey, custom: custom, usePublicKey: true, completion: completion)
    }
    
    func login(sessionId: String, service: Service, account: PublicAccount, rpPublicKey: String?, custom: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let sessionAccount = StorageService.shared.getAllAccounts(serviceId: service.id).first(where: { $0.username == account.username })  else {
            print("no account found")
            completion(.failure(KeyriErrors.accountNotFound))
            return
        }
        
        SessionService.shared.verifyUserSession(encUserId: sessionAccount.userId, sessionId: sessionId, rpPublicKey: rpPublicKey, custom: custom, completion: completion)
    }
}

extension UserService {
    private func createUser(username: String,
                            service: Service,
                            custom: String?) -> (account: Account?, encUserId: String?) {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            assertionFailure(KeyriErrors.identifierForVendorNotFound.errorDescription ?? "")
            return (nil, nil)
        }
        
        let uniqueId = String.random()
        let encryptTarget = "\(deviceId)\(uniqueId)"
        
        let box = KeychainService.shared.getCryptoBox()
        let userIdData = AES.encryptionAESModeECB(messageData: encryptTarget.data(using: .utf8)!, key: box.privateKey)!
        let encUserIdData = AES.encryptionAESModeECB(messageData: userIdData, key: box.privateKey)!
        let encUserId = String(data: encUserIdData, encoding: .utf8)!
                    
        let account = Account(userId: encUserId,
                              username: username,
                              custom: custom)
        StorageService.shared.set(service: service)
        StorageService.shared.add(account: account, serviceId: service.id)
        
        return (account, encUserId)
    }
}