//
//  InitialViewController.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 02.11.2021.
//

import UIKit
import AVFoundation
import keyri_pod
import Toaster

class InitialViewController: UIViewController {

    
    @IBOutlet weak var qrScannerButton: UIButton!
    @IBOutlet weak var mobileSignUpButton: UIButton!
    @IBOutlet weak var mobileLoginButton: UIButton!
    
    enum State {
        case idle, login, signup
    }
    
    var state: State = .idle

    lazy var scanner: QRCodeScannerController = {
        let scanner = QRCodeScannerController(
            cameraImage: UIImage(named: "switch-camera-button"),
            cancelImage: nil,
            flashOnImage: UIImage(named: "flash"),
            flashOffImage: UIImage(named: "flash-off")
        )
        scanner.delegate = self
        
        let label = UILabel()
        label.text = "Powered by Keyri"
        label.sizeToFit()
        scanner.view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: scanner.view.bottomAnchor, constant: -100).isActive = true
        label.centerXAnchor.constraint(equalTo: scanner.view.centerXAnchor).isActive = true
        
        return scanner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func qrScannerButtonTapped(_ sender: Any) {
        self.navigateToListVC()
//        Keyri.shared.authWithScanner(custom: "custom auth with scanner") { (result: Result<Void, Error>) in
//            switch result {
//            case .success():
//                print()
//            case .failure(let error):
//                Toast(text: error.localizedDescription, duration: Delay.long).show()
//            }
//        }
    }
    
    @IBAction func mobileSignUpButtonTapped(_ sender: Any) {
        
        Keyri.shared.mobileSignUp(username: "tester 1", custom: "custom mobile signup", extendedHeaders: ["TestKey1": "TestVal1", "TestKey2": "TestVal2"]) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                Toast(text: error.localizedDescription, duration: Delay.long).show()
            }
        }
    }
    
    @IBAction func mobileLoginButtonTapped(_ sender: Any) {
        Keyri.shared.accounts() { result in
            if case .success(let accounts) = result, let account = accounts.first {
                Keyri.shared.mobileLogin(account: account, custom: "custom mobile signin", extendedHeaders: ["TestKey1": "TestVal1", "TestKey2": "TestVal2"]) { result in
                    switch result {
                    case .success(let response):
                        print(response)
                        self.navigateToListVC()
                    case .failure(let error):
                        Toast(text: error.localizedDescription, duration: Delay.long).show()
                    }
                }
            }
        }
    }
    
    private func navigateToListVC() {
        if let listVC = self.storyboard?.instantiateViewController(identifier: "ListVC") as? ListVC {
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(listVC, animated: false)
        }
    }
}

extension InitialViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        Keyri.shared.onReadSessionId(result) { result in
            switch result {
            case .success(let session):
                switch self.state {
                case .signup:
                    guard let username = session.username else {
                        return
                    }
                    Keyri.shared.signUp(username: username, service: session.service, custom: "test custom signup") { (result: Result<Void, Error>) in
                        switch result {
                        case .success(_):
                            print("Signup successfully completed")
                        case .failure(let error):
                            print("Signup failed: \(error.localizedDescription)")
                            Toast(text: error.localizedDescription, duration: Delay.long).show()
                        }
                    }
                case .login:
                    Keyri.shared.accounts() { result in
                        if case .success(let accounts) = result, let account = accounts.first {
                            Keyri.shared.login(account: account, service: session.service, custom: "test custom login") { (result: Result<Void, Error>) in
                                switch result {
                                case .success(_):
                                    print("Login successfully completed")
                                case .failure(let error):
                                    print("Login failed: \(error.localizedDescription)")
                                    Toast(text: error.localizedDescription, duration: Delay.long).show()
                                }
                            }
                        } else {
                            print("no accounts found")
                            Toast(text: "no accounts found", duration: Delay.long).show()
                        }
                    }
                default:
                    break
                }
            case .failure(let error):
                Toast(text: error.localizedDescription, duration: Delay.long).show()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        dismiss(animated: true, completion: nil)
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
}

