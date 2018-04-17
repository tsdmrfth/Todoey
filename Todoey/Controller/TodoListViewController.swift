//
//  ViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 29.03.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var todoItems : Results<TodoItem>?
    var selectedCategory : TodoItemCategory? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectedCategory?.colour else {
            return
        }
        
        title = selectedCategory?.categoryName
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        
        guard let navBarColor = UIColor(hexString: colourHexCode) else {
            return
        }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    //MARK - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.text
            cell.accessoryType = item.isChecked ? .checkmark : .none
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(2 * todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No TODOs added"
        }
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isChecked = !item.isChecked
                    tableView.reloadData()
                }
            } catch {
                print("An error occured when updating item \(error)")
            }
        }
    }
    
    //MARK - Add New Items
    @IBAction func onAddNewItemButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title : "Add New TODOs", message : "", preferredStyle : .alert)
        
        let action = UIAlertAction(title: "Add TODO", style: .default) { (action) in
            if textField.text?.count != 0{
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newTodoItem = TodoItem()
                            newTodoItem.text = textField.text!
                            newTodoItem.isChecked = false
                            newTodoItem.createdDate = Date()
                            newTodoItem.colour = UIColor.randomFlat.hexValue()
                            currentCategory.items.append(newTodoItem)
                            
                            self.realm.add(newTodoItem)
                        }
                    } catch {
                        print("Error persisting data \(error)")
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "createdDate", ascending: false)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indextPath: IndexPath) {
        if let todoItem = todoItems?[indextPath.row] {
            do {
                try realm.write {
                    realm.delete(todoItem)
                }
            } catch {
                print("An error occured when deleting data \(error)")
            }
        }
    }
    
}

//MARK - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            return
        }
        
        todoItems = todoItems!.filter("text CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "text", ascending: false)
        tableView.reloadData()
    }
}




