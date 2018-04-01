//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 1.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItemCategories : Results<TodoItemCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    //MARK - TableView DataSource Methos
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItemCategories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = todoItemCategories?[indexPath.row].categoryName ?? "No categories added"
        
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
            
            let newTodoItemCategory = TodoItemCategory()
            newTodoItemCategory.categoryName = textField.text!
            
            self.saveItems(category: newTodoItemCategory)
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
            todoListVC.selectedCategory = todoItemCategories?[indexPath.row]
        }
    }
    
    //MARK - Data Manipulation Methods
    func saveItems(category: TodoItemCategory){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(){
        todoItemCategories = realm.objects(TodoItemCategory.self)
        tableView.reloadData()
    }
    
}
