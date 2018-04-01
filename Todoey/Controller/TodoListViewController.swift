//
//  ViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 29.03.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var todoItemArray = [TodoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : TodoItemCategory? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            let newTodoItem = TodoItem(context: self.context)
            newTodoItem.text = textField.text!
            newTodoItem.isChecked = false
            newTodoItem.category = self.selectedCategory!
            
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
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(with request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "category.categoryName MATCHES %@", selectedCategory!.categoryName!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
    
        do {
            todoItemArray = try context.fetch(request)
        } catch {
            print("Error occured when fetching data from context. \(error)")
        }
        
        tableView.reloadData()
    }
    
}

// MARK - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
        
        if searchText.count == 0 {
            loadItems(with : request, predicate: nil)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            return
        }
        
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
       
        loadItems(with: request, predicate: predicate)
    }
}




