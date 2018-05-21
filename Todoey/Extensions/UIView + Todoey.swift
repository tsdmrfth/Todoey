//
//  UIView + Todoey.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 19.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit

extension UIView {
   
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 1.2
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -5.0, 5.0, -2.5, 2.5, -2.5, 2.5, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}
