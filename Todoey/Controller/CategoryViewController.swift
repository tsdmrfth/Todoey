//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 1.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var todoItemCategoryArray = [TodoItemCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    //MARK - TableView DataSource Methos
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItemCategoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = todoItemCategoryArray[indexPath.row]
        
        cell.textLabel?.text = item.categoryName
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoItems", sender: self)
    }
    
    //MARK - Add new items
    @IBAction func onAddNewCategoryButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title : "Add New Category", message : "", preferredStyle : .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newTodoItemCategory = TodoItemCategory(context: self.context)
            newTodoItemCategory.categoryName = textField.text!
            
            self.todoItemCategoryArray.append(newTodoItemCategory)
            
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todoListVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            todoListVC.selectedCategory = todoItemCategoryArray[indexPath.row]
        }
    }
    
    //MARK - Data Manipulation Methods
    func saveItems(){
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(with request : NSFetchRequest<TodoItemCategory> = TodoItemCategory.fetchRequest()){
        do {
            todoItemCategoryArray = try context.fetch(request)
        } catch {
            print("Error occured when fetching data from context. \(error)")
        }
        
        tableView.reloadData()
    }
    
}
