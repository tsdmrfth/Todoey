//
//  ViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 29.03.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Go to shop", "Kill some people", "Buy weed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    //MARK - Add New Items
    @IBAction func onAddNewItemButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title : "Add New TODOs", message : "", preferredStyle : .alert)
        
        let action = UIAlertAction(title: "Add TODO", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            print(self.itemArray)
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

