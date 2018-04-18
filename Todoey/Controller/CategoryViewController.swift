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
import SwiftEventBus
import Foundation

class CategoryViewController: UIViewController {
    
    fileprivate var categoryView: CategoryView {
        return self.view as! CategoryView
    }
    
    private let realm = try! Realm()
    private var todoItemCategories : [TodoItemCategory]?
    
    //MARK - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        SwiftEventBus.onMainThread(self, name: Constant.onDeleteButtonClicked) { (event) in
            let deleteButtonEvent = event.object as! DeleteButtonEvent
            let category = deleteButtonEvent.itemToDelete as! TodoItemCategory
            self.deleteCategory(category)
        }
        
        SwiftEventBus.onMainThread(self, name: Constant.onSaveButtonClicked) { (event) in
            let saveButtonEvent = event.object as! SaveButtonEvent
            let category = saveButtonEvent.itemToUpdate as! TodoItemCategory
            let property = saveButtonEvent.itemPropertyToUpdate
            
            self.updateCategory(category, property!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SwiftEventBus.unregister(self)
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
                newTodoItemCategory.createDate = Date().toString(format: "EEE, dd MMM yyyy HH:mm")
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
    fileprivate func saveItems(category: TodoItemCategory){
        do{
            try realm.write {
                realm.add(category)
                self.categoryView.addCategory(category: category)
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    fileprivate func deleteCategory(_ category: TodoItemCategory) {
        do {
            try realm.write {
                realm.delete(category)
                
                todoItemCategories = sortCategoriesByDate()
                
                guard let categories = todoItemCategories else {
                    return
                }
                
                categoryView.refreshCategories(categories.reversed())
                
            }
        } catch {
            print("Error deleting context \(error)")
        }
    }
    
    fileprivate func updateCategory(_ category: TodoItemCategory, _ property: String){
        do {
            try realm.write {
                category.categoryName = property
                category.createDate = Date().toString(format: "EEE, dd MMM yyyy HH:mm")
                
                todoItemCategories = sortCategoriesByDate()
                
                guard let categories = todoItemCategories else {
                    return
                }
                
                categoryView.refreshCategories(categories.reversed())
            }
        } catch  {
            print("Error updating context \(error)")
        }
    }
    
    fileprivate func loadItems(){
        todoItemCategories = sortCategoriesByDate()
        
        view = CategoryView(categories: todoItemCategories!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAddNewCategoryButtonClicked(_:)))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.flatGray]
        navigationController?.navigationBar.tintColor = UIColor.flatGray
        
        title = "Todoey"
    }
    
    fileprivate func sortCategoriesByDate() -> [TodoItemCategory] {
        let categories = realm.objects(TodoItemCategory.self)
        
        let reversedArray: Array = categories.reversed()
        
        return reversedArray.sorted(by: { $0.createDate.compare($1.createDate) == ComparisonResult.orderedDescending })
    }
    
}



