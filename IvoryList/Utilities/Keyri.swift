//
//  Keyri.swift
//  IvoryList
//
//  Created by atomic on 02.11.2021.
//

import Foundation

public final class Keyri: NSObject {
    
    private var appkey: String!
    private var rpPublicKey: String?
    private var callbackUrl: URL!
    
    private var scanner: Scanner?
    
    @objc
    public static let shared = Keyri()
    
    private override init() {}
    
    @objc
    public func initialize(appkey: String, rpPublicKey: String? = nil, callbackUrl: URL) {
        self.appkey = appkey
        self.rpPublicKey = rpPublicKey
        self.callbackUrl = callbackUrl

        let _ = KeychainService.shared.getCryptoBox()
    }
    
    public func authWithScanner(from viewController: UIViewController? = nil, custom: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        scanner = Scanner()
        scanner?.completion = { [weak self] result in
            self?.onReadSessionId(result, completion: { sessionResult in
                switch sessionResult {
                case .success(let session):
                    if session.isNewUser {
                        guard let username = session.username else { return }
                        self?.signUp(username: username, service: session.service, custom: custom, completion: completion)
                    } else {
                        self?.accounts() { result in
                            if case .success(let accounts) = result, let account = accounts.first {
                                Keyri.shared.login(account: account, service: session.service, custom: custom, completion: completion)
                            } else {
                                completion(.failure(KeyriErrors.accountNotFound))
                            }
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
        scanner?.show()
    }

}
