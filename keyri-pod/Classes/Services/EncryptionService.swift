//
//  EncryptionService.swift
//  Keyri
//
//  Created by Andrii Novoselskyi on 28.08.2021.
//

import Foundation
import Sodium

struct CryptoBox {
    let publicKey: String
    let privateKey: String

    var publicBuffer: [UInt8]? {
        guard let nsData = NSData(base64Encoded: publicKey, options: .ignoreUnknownCharacters) else {
            return nil
        }
        let bytes = [UInt8](nsData as Data)
        return bytes
    }
}

final class EncryptionService {
    func generateCryproBox() -> CryptoBox? {
        let sodium = Sodium()
        guard let keyPair = sodium.sign.keyPair() else {
            return nil
        }
        let publicKeyString = keyPair.publicKey.base64EncodedString()
        let privateKeyString = keyPair.secretKey.base64EncodedString()
        
        return CryptoBox(publicKey: publicKeyString, privateKey: privateKeyString)
    }
        
    func encryptSeal(string: String, publicKey: String) -> String? {
        let stringBytes = string.bytes
        let sodium = Sodium()
        
        guard let publicKeyBytes = publicKey.base64EncodedData() else {
            return nil
        }
        
        let sealResult = sodium.box.seal(message: stringBytes, recipientPublicKey: publicKeyBytes)
        
        return sealResult?.base64EncodedString()
    }
    
    func createSignature(string: String, privateKey: String) -> String? {
        let stringBytes = string.bytes
        let sodium = Sodium()
        
        guard let privateKeyBytes = privateKey.base64EncodedData() else {
            return nil
        }
        
        let signature = sodium.sign.signature(message: stringBytes, secretKey: privateKeyBytes)
        
        return signature?.base64EncodedString()
    }
}

extension EncryptionService {
    func loadKey(name: String = "com.novos.keyri.Keyri") throws -> SecKey {
//        return (try KeychainHelper.makeAndStoreKey(name: name))
//        if let key = KeychainHelper.loadKey(name: name) {
//            return key
//        } else {
            return (try KeychainHelper.makeAndStoreKey(name: name))
//        }
    }
    
    func loadPublicKey(name: String = "com.novos.keyri.Keyri") throws -> SecKey? {
        if let key = KeychainHelper.loadKey(name: name) {
            return SecKeyCopyPublicKey(key)
        } else {
            let key = (try KeychainHelper.makeAndStoreKey(name: name))
            return SecKeyCopyPublicKey(key)
        }
    }
        
    func ecdhEncrypt(string: String, publicKey: String) -> String? {
        guard
            let publicSecKey = KeychainHelper.convertbase64StringToSecKey(stringKey: publicKey)
        else { return nil }
        
        guard let data = string.data(using: .utf8) else { return nil }
        let encryptedData = SecKeyCreateEncryptedData(publicSecKey, .eciesEncryptionCofactorX963SHA256AESGCM, data as CFData, nil) as Data?
        return encryptedData?.base64EncodedString()
    }
    
    func ecdhDecrypt(string: String) -> String? {
        guard let privateSecKey = try? loadKey() else { return nil }
        guard let data = Data(base64Encoded: string) else { return nil }
        let decryptedData = SecKeyCreateDecryptedData(privateSecKey, .eciesEncryptionCofactorX963SHA256AESGCM, data as CFData, nil) as Data?
        return decryptedData?.utf8String()
    }
    
    func ecdhCreateSignature(string: String) -> String? {
        guard let privateKey = try? loadKey() else { return nil }
        guard let data = string.data(using: .utf8) else { return nil }
        let signature = SecKeyCreateSignature(privateKey, .ecdsaSignatureMessageX962SHA256, data as CFData, nil) as Data?
        return signature?.base64EncodedString()
    }
    
    func ecdhValidateSignature(string: String, signatureString: String) -> Bool {
        guard
            let privateKey = try? loadKey(),
            let publicKey = SecKeyCopyPublicKey(privateKey)
        else { return false }
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        guard
            SecKeyIsAlgorithmSupported(publicKey, .verify, algorithm),
            let clearTextData = string.data(using: .utf8),
            let signatureData = Data(base64Encoded: signatureString)
        else {
            return false
        }
        guard SecKeyVerifySignature(publicKey, algorithm, clearTextData as CFData, signatureData as CFData, nil) else {
            return false
        }
        
        return true
    }
    
    func aesEncrypt(string: String) -> String? {
        guard
            let privateKey = try? loadKey(),
            let publicKey = SecKeyCopyPublicKey(privateKey)
        else { return nil }
        guard let data = string.data(using: .utf8) else { return nil }
        let encryptedData = SecKeyCreateEncryptedData(publicKey, .eciesEncryptionStandardX963SHA256AESGCM, data as CFData, nil) as Data?
        return encryptedData?.base64EncodedString()
    }
    
    func aesDecrypt(string: String) -> String? {
        guard let privateKey = try? loadKey() else { return nil }
        guard let data = Data(base64Encoded: string) else { return nil }
        let decryptedData = SecKeyCreateDecryptedData(privateKey, .eciesEncryptionStandardX963SHA256AESGCM, data as CFData, nil) as Data?
        return decryptedData?.utf8String()
    }
    
    func exchangeTest() throws {
        let attributes: [String: Any] =
            [kSecAttrKeySizeInBits as String:      256,
             kSecAttrKeyType as String: kSecAttrKeyTypeEC,
             kSecPrivateKeyAttrs as String:
                [kSecAttrIsPermanent as String:    false]
        ]

        var error: Unmanaged<CFError>?
        if #available(iOS 10.0, *) {
            // generate a key for alice
//            guard let privateKey1 = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
//                throw error!.takeRetainedValue() as Error
//            }
//            let publicKey1 = SecKeyCopyPublicKey(privateKey1)
//
//            // generate a key for bob
//            guard let privateKey2 = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
//                throw error!.takeRetainedValue() as Error
//            }
//            let publicKey2 = SecKeyCopyPublicKey(privateKey2)
//
//            let dict: [String: Any] = [:]
//
//            // alice is calculating the shared secret
//            guard let shared1 = SecKeyCopyKeyExchangeResult(privateKey1, SecKeyAlgorithm.ecdhKeyExchangeCofactor, publicKey2!, dict as CFDictionary, &error) else {
//                throw error!.takeRetainedValue() as Error
//            }
//
//            // bob is calculating the shared secret
//            guard let shared2 = SecKeyCopyKeyExchangeResult(privateKey2, SecKeyAlgorithm.ecdhKeyExchangeCofactor, publicKey1!, dict as CFDictionary, &error) else {
//                throw error!.takeRetainedValue() as Error
//            }
//
//            print(shared1==shared2)
            
            let secKey = try loadKey()
            let serverPublicKey = KeychainHelper.convertbase64StringToSecKey(stringKey: "BOenio0DXyG31mAgUCwhdslelckmxzM7nNOyWAjkuo7skr1FhP7m2L8PaSRgIEH5ja9p+CwEIIKGqR4Hx5Ezam4=")!
            let dict: [String: Any] = [:]
            // alice is calculating the shared secret
            guard let shared1 = SecKeyCopyKeyExchangeResult(secKey, SecKeyAlgorithm.ecdhKeyExchangeCofactor, serverPublicKey, dict as CFDictionary, &error) as? Data else {
                throw error!.takeRetainedValue() as Error
            }
            
            print(shared1.base64EncodedString())


        } else {
            // Fallback on earlier versions
            print("unsupported")
        }
    }
}

extension Bytes {
    func base64EncodedString() -> String {
        Data(self).base64EncodedString()
    }
}

extension String {
    func base64EncodedData() -> [UInt8]? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return [UInt8](data)
    }
}

final class KeychainHelper {
    static func makeAndStoreKey(name: String) throws -> SecKey {
        removeKey(name: name)

        let parameters: [String: AnyObject] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                   kSecAttrKeySizeInBits as String:    256 as AnyObject,
                   ]
               var pubKey, privKey: SecKey?
               let status = SecKeyGeneratePair(parameters as CFDictionary, &pubKey, &privKey)
               guard status == 0, let newPubKey = pubKey, let newPrivKey = privKey else {
                   throw ECError.failedNativeKeyCreation
               }
               var error: Unmanaged<CFError>? = nil
               guard let pubBytes = SecKeyCopyExternalRepresentation(newPubKey, &error) else {
                   guard let error = error?.takeRetainedValue() else {
                       throw ECError.failedNativeKeyCreation
                   }
                   throw error
               }
       
                let publicKeyNSData = NSData(data: pubBytes as Data)
        
        // Usage
        let publicKeyDER = createSubjectPublicKeyInfo(rawPublicKeyData: publicKeyNSData as Data)
        
        let publicKeyBase64Str = publicKeyDER.base64EncodedString()
        
        let serverPublicKey = KeychainHelper.convertbase64StringToSecKey(stringKey: "BOenio0DXyG31mAgUCwhdslelckmxzM7nNOyWAjkuo7skr1FhP7m2L8PaSRgIEH5ja9p+CwEIIKGqR4Hx5Ezam4=")!
        let dict: [String: Any] = [:]
        // alice is calculating the shared secret
        guard let shared1 = SecKeyCopyKeyExchangeResult(privKey!, SecKeyAlgorithm.ecdhKeyExchangeCofactor, serverPublicKey, dict as CFDictionary, &error) as? Data else {
            throw error!.takeRetainedValue() as Error
        }
        print(shared1.base64EncodedString())

        
        return privKey!
    }
    
    static func createSubjectPublicKeyInfo(rawPublicKeyData: Data) -> Data {
        let secp256r1Header = Data(bytes: [
            0x30, 0x59, 0x30, 0x13, 0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, 0x01, 0x06, 0x08, 0x2a,
            0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07, 0x03, 0x42, 0x00
            ])
        return secp256r1Header + rawPublicKeyData
    }
    
    static func loadKey(name: String) -> SecKey? {
        guard let tag = name.data(using: .utf8) else { return nil }
        let query: [String: Any] = [
            kSecClass as String                 : kSecClassKey,
            kSecAttrApplicationTag as String    : tag,
            kSecAttrKeyType as String           : kSecAttrKeyTypeEC,
            kSecReturnRef as String             : true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let key = item else {
            return nil
        }
        return (key as! SecKey)
    }
    
    static func removeKey(name: String) {
        let tag = name.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String                 : kSecClassKey,
            kSecAttrApplicationTag as String    : tag
        ]

        SecItemDelete(query as CFDictionary)
    }
    
    static func convertSecKeyToBase64String(secKey: SecKey) -> String? {
        var error: Unmanaged<CFError>?
        
        guard let keyData = SecKeyCopyExternalRepresentation(secKey, &error) as Data? else {
            fatalError()
        }
        let keyString = keyData.base64EncodedString()
        return keyString
    }
    
    static func convertbase64StringToSecKey(stringKey: String) -> SecKey? {
        guard let keyData = Data(base64Encoded: stringKey) else { return nil }
                
        let keyDict:[String: Any] = [
           kSecAttrKeyType as String: kSecAttrKeyTypeEC,
           kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
        ]
        
        return SecKeyCreateWithData(keyData as CFData, keyDict as CFDictionary, nil)
    }
}
