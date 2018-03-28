//
//  ViewController.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 29.03.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Go to shop", "Kill some people", "Buy weed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

}

