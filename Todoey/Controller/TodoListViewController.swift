//
//  ViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 29.03.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var todoItemArray = [TodoItem]()
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItemList.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        
        let item = todoItemArray[indexPath.row]
        
        cell.textLabel?.text = item.text
        
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        saveItems()
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoItemArray[indexPath.row].isChecked = !todoItemArray[indexPath.row].isChecked
        tableView.reloadData()
    }
    
    //MARK - Add New Items
    @IBAction func onAddNewItemButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title : "Add New TODOs", message : "", preferredStyle : .alert)
        
        let action = UIAlertAction(title: "Add TODO", style: .default) { (action) in
            
            let newTodoItem = TodoItem()
            newTodoItem.text = textField.text!
            
            self.todoItemArray.append(newTodoItem)
            
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data Manipulation Methods
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(todoItemArray)
            try data.write(to: filePath!)
        } catch {
            print("Error occured when encoding data.")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: filePath!) {
            let decoder = PropertyListDecoder()
            do {
                todoItemArray = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error occured when decoding data.")
            }
        }
    }
    
}

