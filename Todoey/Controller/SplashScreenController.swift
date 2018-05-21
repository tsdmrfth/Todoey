//
//  SplashScreenController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 19.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import RealmSwift

class SplashScreenController: UIViewController {
    
    fileprivate let realm = try! Realm()
    fileprivate var splashScreenView: SplashScreenView {
        return self.view as! SplashScreenView
    }
    
    override func viewDidLoad() {
        loadItems()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        loadView()
    }
    
    override func loadView() {
        view = SplashScreenView()
    }
    
    fileprivate func loadItems(){
        let categoryVC = CategoryViewController()
        categoryVC.todoItemCategories = sortCategoriesByDate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = categoryVC
        })
    }
    
    fileprivate func sortCategoriesByDate() -> [TodoItemCategory] {
        let categories = realm.objects(TodoItemCategory.self).sorted(byKeyPath: "createDate", ascending: false)
        
        print(categories)
        
        return categories.toArray(ofType: TodoItemCategory.self);
    }
    
}
