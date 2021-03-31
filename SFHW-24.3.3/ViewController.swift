//
//  ViewController.swift
//  SFHW-24.3.3
//
//  Created by Mykhailo Romanovskyi on 31.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    //Определяем свойста
    private let reuseId = "myCell"
    private let model = Model()
    
    private var tableView: UITableView!
    private var alert = UIAlertController()
    private var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
    }
    
    //Метод для настройки ВьюКонтроллера, конкретно TableView
    private func setupTableView() {
        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Метод для настройки ВьюКонтроллера, конкретно NavigationBar
    private func setupNavBar() {
        title = "Task"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(image: UIImage.add, style: .plain, target: self, action: #selector(addTaskAction))
        editButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up"), style: .plain, target: self, action: #selector(sortAction))
        
        navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    @objc private func sortAction() {
        let arrowUp = UIImage(systemName: "arrow.up")
        let arrowDown = UIImage(systemName: "arrow.down")
        
        model.sortedAscending = !model.sortedAscending
        editButton.image = model.sortedAscending ? arrowUp : arrowDown
        model.sortByTitle()
        tableView.reloadData()
    }
    @objc private func addTaskAction() {
        alert = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Put your task here"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        let createAlertAction = UIAlertAction(title: "Create", style: .default) { (createAlert) in
            guard let unwrTextFieldValue = self.alert.textFields?[0].text else {
                return
            }
            
            self.model.addItem(itemName: unwrTextFieldValue)
            self.model.sortByTitle()
            self.tableView.reloadData()
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAlertAction)
        alert.addAction(createAlertAction)
        present(alert, animated: true, completion: nil)
        createAlertAction.isEnabled = false
    }
}

//MARK:- Extension для TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! MyTableViewCell
        
        cell.myLabel.text = model.toDoItems[indexPath.row].string
        cell.accessoryType = model.toDoItems[indexPath.row].completed ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = model.changeState(at: indexPath.row) ? .checkmark : .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.editCellContent(indexPath: indexPath)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.model.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            //Не совсем понимаю зачем нужен этот хандлер
            completionHandler(true)
            
        }
        editAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func editCellContent(indexPath: IndexPath) {
        
        let cell = tableView(tableView, cellForRowAt: indexPath) as! MyTableViewCell
        alert = UIAlertController(title: "Edit your task", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField.text = cell.myLabel.text
            
        })
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let editAlertAction = UIAlertAction(title: "Submit", style: .default) { (createAlert) in
            
            guard let textFields = self.alert.textFields, textFields.count > 0 else{
                return
            }
            
            guard let textValue = self.alert.textFields?[0].text else {
                return
            }
            
            self.model.updateItem(at: indexPath.row, with: textValue)
            
            self.tableView.reloadData()
            
        }
        
        alert.addAction(cancelAlertAction)
        alert.addAction(editAlertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        
        guard let senderText = sender.text, alert.actions.indices.contains(1) else {
            return
        }
        let action = alert.actions[1]
        action.isEnabled = senderText.count > 0
    }
}
