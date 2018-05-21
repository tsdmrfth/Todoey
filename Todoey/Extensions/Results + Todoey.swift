//
//  Results + Todoey.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 19.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import RealmSwift

extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
    
}
