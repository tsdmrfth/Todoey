//
//  DeleteButtonEvent.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 18.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

class DeleteButtonEvent {
    
    var itemToDelete: Any!
    
    init(item: Any) {
        self.itemToDelete = item
    }
    
}
