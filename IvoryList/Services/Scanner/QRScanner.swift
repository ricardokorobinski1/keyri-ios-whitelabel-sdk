//
//  QRScanner.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 03.11.2021.
//

import UIKit
import QRCodeReader
import AVFoundation

public class QRScanner {
    var completion: ((String) -> Void)?
    
    private var targetViewController: UIViewController?
    private var presentationController: UIViewController? {
        if let targetViewController = targetViewController {
            return targetViewController
        } else {
            return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
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


//public class QRScanner {
//    var completion: ((String) -> Void)?
//
//    private var targetViewController: UIViewController?
//    private var presentationController: UIViewController? {
//        if let targetViewController = targetViewController {
//            return targetViewController
//        } else {
//            return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
//        }
//    }
//
//    private lazy var readerVC: QRCodeReaderViewController = {
//        let builder = QRCodeReaderViewControllerBuilder {
//            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
//
//            $0.showTorchButton        = true
//            $0.showSwitchCameraButton = true
//            $0.showCancelButton       = true
//            $0.showOverlayView        = true
//            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
//        }
//
//        return QRCodeReaderViewController(builder: builder)
//    }()
//
//    init() {
//        readerVC.delegate = self
//        readerVC.modalPresentationStyle = .formSheet
//
//        setupPoweredLabel()
//    }
//
//    func show(from viewController: UIViewController? = nil) {
//        targetViewController = viewController
//        presentationController?.present(readerVC, animated: true, completion: nil)
//    }
//}
//
//public extension QRScanner {
//    private func setupPoweredLabel() {
//        let label = UILabel()
//        label.text = "Powered by Keyri"
//        label.sizeToFit()
//        readerVC.view.addSubview(label)
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.bottomAnchor.constraint(equalTo: readerVC.view.bottomAnchor, constant: -50).isActive = true
//        label.centerXAnchor.constraint(equalTo: readerVC.view.centerXAnchor).isActive = true
//    }
//}
//
//extension QRScanner: QRCodeReaderViewControllerDelegate {
//    public func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
//        reader.stopScanning()
//        completion?(result.value)
//        presentationController?.dismiss(animated: true, completion: nil)
//    }
//
//    public func readerDidCancel(_ reader: QRCodeReaderViewController) {
//        reader.stopScanning()
//        presentationController?.dismiss(animated: true, completion: nil)
//    }
//}
