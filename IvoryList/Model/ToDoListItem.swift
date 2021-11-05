//
//  ToDoListItem.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 04.11.2021.
//

import Foundation

struct ToDoListItem {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

protocol ToDoListItemProtocol {
    var name: String { get }
}
