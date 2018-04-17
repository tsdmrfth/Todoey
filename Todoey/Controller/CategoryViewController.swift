//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 1.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework
import FlexLayout

class CategoryViewController: UIViewController {
    
    fileprivate var categoryView: CategoryView {
        return self.view as! CategoryView
    }
    
    private let realm = try! Realm()
    private var todoItemCategories : Results<TodoItemCategory>?
    
    //MARK - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK - Add new items
    @objc func onAddNewCategoryButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title : "Add New Category", message : "", preferredStyle : .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text?.count != 0 {
                let newTodoItemCategory = TodoItemCategory()
                newTodoItemCategory.categoryName = textField.text!
                newTodoItemCategory.colour = UIColor.randomFlat.hexValue()
                self.saveItems(category: newTodoItemCategory)
            }
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let todoListVC = segue.destination as! TodoListViewController
    //
    //        if let indexPath = tableView.indexPathForSelectedRow {
    //            todoListVC.selectedCategory = todoItemCategories?[indexPath.row]
    //        }
    //    }
    
    //MARK - Data Manipulation Methods
    func saveItems(category: TodoItemCategory){
        do{
            try realm.write {
                realm.add(category)
                self.categoryView.addCategory(category: category)
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(){
        todoItemCategories = realm.objects(TodoItemCategory.self)
        
        view = CategoryView(categories: todoItemCategories!)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAddNewCategoryButtonClicked(_:)))
        //tableView.reloadData()
    }
    
}



