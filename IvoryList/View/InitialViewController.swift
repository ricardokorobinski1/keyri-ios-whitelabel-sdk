//
//  InitialViewController.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 02.11.2021.
//

import UIKit

class InitialViewController: UIViewController {

    
    @IBOutlet weak var qrScannerImageView: UIImageView!
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

    private func mobileSignUp() {
        
    }
    private func mobileLogin() {
        
    }
    private func authWithScanner() {
        Keyri.shared.authWithScanner(custom: "custom auth with scanner") { (result: Result<Void, Error>) in
            switch result {
            case .success():
                print()
            case .failure(let error):
                Toast(text: error.localizedDescription, duration: Delay.long).show()
            }
        }

    }
}

