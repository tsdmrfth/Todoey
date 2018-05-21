//
//  UpdateButtonEvent.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 18.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

class SaveButtonEvent {
    
    var itemToUpdate: Any!
    var itemPropertyToUpdate: String!
    
    init(item: Any, itemProperty: String) {
        self.itemToUpdate = item
        self.itemPropertyToUpdate = itemProperty
    }
    
}
