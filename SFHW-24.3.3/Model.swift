//
//  Model.swift
//  SFHW-24.3.3
//
//  Created by Mykhailo Romanovskyi on 31.03.2021.
//

class Item {
    var string: String
    var completed: Bool
    
    init(string: String, completed: Bool) {
        self.string = string
        self.completed = completed
    }
}

class Model {
    var sortedAscending: Bool = true
    var toDoItems: [Item] = [
                            Item(string: "Do something", completed: false),
                            Item(string: "Task1", completed: true),
                            Item(string: "Create app", completed: false),
                            ]
    
    func addItem(itemName: String, isCompleted: Bool = false) {
        toDoItems.append(Item(string: itemName, completed: isCompleted))
    }
    func changeState(at item: Int) -> Bool {
        
        toDoItems[item].completed =  !toDoItems[item].completed
        
        return toDoItems[item].completed
    }
    
    func removeItem(at index: Int) {
        toDoItems.remove(at: index)
    }
    
    func updateItem(at index: Int, with string: String) {
        toDoItems[index].string = string
    }
    
    func sortByTitle() {
        toDoItems.sort {
            sortedAscending ? $0.string < $1.string : $0.string > $1.string
        }
    }
}
