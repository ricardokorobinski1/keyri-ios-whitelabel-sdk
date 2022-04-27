//
//  ECDHUtil.swift
//  CryptoSwift
//
//  Created by Aditya Malladi on 4/27/22.
//

import Foundation
import CryptoKit

@available(iOS 13.0, *)
class ECDHUtil {
    public func deriveSharedSecret(from data: Data, with privateKey: P256.KeyAgreement.PrivateKey) -> SharedSecret? {
        do {
            let publicKey = try P256.KeyAgreement.PublicKey(rawRepresentation: data)
            let shared = try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
            
            return shared
        } catch {
            print(error)
            return nil
        }
    }
    
    public func generateSymmetricKey(from sharedSecret: SharedSecret, salt: String) -> SymmetricKey {
        let protocolSalt = salt.data(using: .utf8)!
        return sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: protocolSalt, sharedInfo: Data(), outputByteCount: 32)
    }
}
