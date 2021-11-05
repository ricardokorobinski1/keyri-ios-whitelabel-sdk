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
    
    var data: [ToDoListItem] = []
    
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
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    private func hideTable(_ tableIsHidden: Bool) {
        self.table.isHidden = tableIsHidden
        self.table.isUserInteractionEnabled = !tableIsHidden
        
        self.startButton.isHidden = !tableIsHidden
        self.startButton.isUserInteractionEnabled = tableIsHidden
    }
    
    private func getList() {
        SessionService.shared.getToDoList() // -> data
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
