//
//  ListVC.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 04.11.2021.
//

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
    }
    
    private func initialSetup() {
        self.hideTable(false)
    }
    
    private func hideTable(_ tableIsHidden: Bool) {
        self.table.isHidden = tableIsHidden
        self.table.isUserInteractionEnabled = !tableIsHidden
        
        self.startButton.isHidden = !tableIsHidden
        self.startButton.isUserInteractionEnabled = tableIsHidden
    }
}
