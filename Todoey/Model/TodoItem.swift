//
//  TodoItem.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 1.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import RealmSwift

class TodoItem: Object {
    
    @objc dynamic var text : String = ""
    @objc dynamic var isChecked : Bool = false
    @objc dynamic var createdDate : Date?
    var parentCatgory = LinkingObjects(fromType: TodoItemCategory.self, property: "items")
    
}
