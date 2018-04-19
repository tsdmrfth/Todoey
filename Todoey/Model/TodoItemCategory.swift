//
//  TodoItemCategory.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 1.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import RealmSwift

class TodoItemCategory: Object {

    @objc dynamic var categoryName: String = ""
    @objc dynamic var colour: String = ""
    let items = List<TodoItem>()
    @objc dynamic var createDate: Date!
    
}
