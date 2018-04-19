//
//  SplashScreenView.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 19.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import PinLayout
import FlexLayout
import ChameleonFramework

class SplashScreenView: UIView {
    
    fileprivate let rootFlexContainer = UIView()
    fileprivate let logoImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initializeView(){
        self.backgroundColor = UIColor.flatYellow
        
        logoImageView.image = UIImage(named: Constant.logo)
        
        rootFlexContainer.addSubview(logoImageView)
        addSubview(rootFlexContainer)
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    fileprivate func layout(){
        rootFlexContainer.pin.all()
        
        logoImageView.pin.hCenter().vCenter().size(UIScreen.main.bounds.width / 2)
    }
    
}
