//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 1.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import FlexLayout
import SwiftEventBus

class CategoryViewController: UIViewController {
    
    fileprivate let realm = try! Realm()
    fileprivate var categoryView: CategoryView {
        return self.view as! CategoryView
    }
    
    var todoItemCategories : [TodoItemCategory]?{
        didSet {
            self.loadView()
        }
    }
    
    //MARK - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEventDelegates()
    }
    
    override func loadView() {
        view = CategoryView(categories: todoItemCategories!)
        
        title = Constant.Todoey
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SwiftEventBus.unregister(self)
    }
    
    fileprivate func addEventDelegates(){
        
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
    
    //MARK - Data Manipulation Methods
    fileprivate func saveItems(category: TodoItemCategory){
        do{
            try realm.write {
                realm.add(category)
                todoItemCategories = sortCategoriesByDate()
                
                guard let categories = todoItemCategories else {
                    return
                }
                
                categoryView.refreshCategories(categories)
            }
        } catch {
            fatalError("Error saving context \(error)")
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
                
                categoryView.refreshCategories(categories)
                
            }
        } catch {
            fatalError("Error deleting context \(error)")
        }
    }
    
    fileprivate func updateCategory(_ category: TodoItemCategory, _ property: String){
        do {
            try realm.write {
                category.categoryName = property
                category.createDate = Date()
                
                todoItemCategories = sortCategoriesByDate()
                
                guard let categories = todoItemCategories else {
                    return
                }
                
                categoryView.refreshCategories(categories)
            }
        } catch  {
            fatalError("Error updating context \(error)")
        }
    }
    
    fileprivate func sortCategoriesByDate() -> [TodoItemCategory] {
        let categories = realm.objects(TodoItemCategory.self).sorted(byKeyPath: "createDate", ascending: false)
        
        return categories.toArray(ofType: TodoItemCategory.self);
    }
    
}



