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
    
    private var data: [ToDoListItem] = [] {
        didSet {
            hideTable(data.isEmpty)
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.getList()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        self.hideTable(false)
    }
    
    private func initialSetup() {
        self.hideTable(true)
        self.inputTextField.delegate = self
        
        self.table.register(UINib(nibName: "ListTableCell", bundle: nil),
                            forCellReuseIdentifier: "ListTableCell")
        self.table.delegate = self
        self.table.dataSource = self
        self.table.separatorStyle = .none
        
    }
    
    private func hideTable(_ tableIsHidden: Bool) {
        self.table.isHidden = tableIsHidden
        self.table.isUserInteractionEnabled = !tableIsHidden
        
        self.startButton.isHidden = !tableIsHidden
        self.startButton.isUserInteractionEnabled = tableIsHidden
    }
    
    private func getList() {
        URLSessionService.shared.getToDoList { [weak self] queryOutput, errorMessage in
            
            if let result = queryOutput {
                self?.data = result
            }
            
            if !errorMessage.isEmpty {
                print("XYZ Error: " + errorMessage)
            }
            //imlemenmt error servise
        }
    }
    
    private func updateToDoWithNewItem(_ toDoString: String) {
        self.data.append(ToDoListItem(name: toDoString))
    }
}


extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = self.table.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as? ListTableCell else {
            return UITableViewCell()
        }
        let model = self.data[indexPath.row]
        cell.setupCell(model.name)
        
        return cell
    }
}

extension ListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = self.inputTextField.text, text != "" {
            self.updateToDoWithNewItem(text)
            textField.text = nil
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideTable(false)
        }

}
