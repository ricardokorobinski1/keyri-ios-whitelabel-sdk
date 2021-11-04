//
//  KeyChaineAccess.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 02.11.2021.
//

import Foundation
import KeychainAccess

final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    private lazy var keychain = Keychain(service: "com.novos.keyri.Keyri")
    
    func setCryptoBox(_ box: CryptoBox) {
        keychain["publicKey"] = box.publicKey
        keychain["privateKey"] = box.privateKey
    }
    
    func getCryptoBox() -> CryptoBox {
        guard let publicKey = getPublicKey(), let privateKey = getPrivateKey() else {
            let box = EncryptionService.shared.generateCryproBox()
            setCryptoBox(box)
            return box
        }
        return CryptoBox(publicKey: publicKey, privateKey: privateKey)
    }
    
    func set(value: String, forKey key: String) {
        keychain[key] = value
    }
    
    func get(valueForKey key: String) -> String? {
        keychain[key]
    }
}

extension KeychainService {
    private func getPublicKey() -> String? {
        keychain["publicKey"]
    }

    private func getPrivateKey() -> String? {
        keychain["privateKey"]
    }
}