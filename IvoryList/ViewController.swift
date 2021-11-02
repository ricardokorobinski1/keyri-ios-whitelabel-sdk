//
//  ViewController.swift
//  IvoryList
//
//  Created by atomic on 02.11.2021.
//

import UIKit

class InitialViewController: UIViewController {

    
    @IBOutlet weak var qrScannerImageView: UIImageView!
    @IBOutlet weak var qrScannerButton: UIButton!
    
    @IBOutlet weak var mobileSignUpButton: UIButton!
    @IBOutlet weak var mobileLoginButton: UIButton!
    
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

