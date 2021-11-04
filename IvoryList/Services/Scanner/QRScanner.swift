//
//  QRScanner.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 03.11.2021.
//

import UIKit
//import QRCodeReader
import AVFoundation

public class QRScanner {
    var completion: ((String) -> Void)?
    
    private var targetViewController: UIViewController?
    private var presentationController: UIViewController? {
        if let targetViewController = targetViewController {
            return targetViewController
        } else {
            let topVC = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
            print("topVC", topVC)
            return topVC
        }
    }
    
    func show(from viewController: UIViewController? = nil) {
        targetViewController = viewController
        let scanner = QRCodeScannerController(
            cameraImage: UIImage(named: "switch-camera-button"),
            cancelImage: nil,
            flashOnImage: UIImage(named: "flash"),
            flashOffImage: UIImage(named: "flash-off")
        )
        scanner.delegate = self
        presentationController?.present(scanner, animated: true, completion: nil)
        
        let label = UILabel()
        label.text = "Powered by Keyri"
        label.sizeToFit()
        scanner.view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: scanner.view.bottomAnchor, constant: -100).isActive = true
        label.centerXAnchor.constraint(equalTo: scanner.view.centerXAnchor).isActive = true
    }
}

extension QRScanner: QRScannerCodeDelegate {
    
    public func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        completion?(result)
        presentationController?.dismiss(animated: true, completion: nil)
    }
    
    public func qrScannerDidFail(_ controller: UIViewController, error: String) {
        presentationController?.dismiss(animated: true, completion: nil)
    }
    
    public func qrScannerDidCancel(_ controller: UIViewController) {
        presentationController?.dismiss(animated: true, completion: nil)
    }
}
