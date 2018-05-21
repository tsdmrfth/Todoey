//
//  Date + Todoey.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 18.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

