//
//  UILabel + Todoey.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 17.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit

extension UILabel {
    
    func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 50, left: 20, bottom: 50, right: 20)
        drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
}
