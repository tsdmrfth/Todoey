//
//  CategoryView.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 17.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout
import RealmSwift

class CategoryView: UIView {
    
    fileprivate let categoriesScrollView = UIScrollView()
    fileprivate let rootFlexContainer = UIView()
    fileprivate var todoItemCategories: [TodoItemCategory]?
    
    init(categories: [TodoItemCategory]) {
        self.todoItemCategories = categories
        
        super.init(frame: .zero)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initializeView(){
        self.backgroundColor = .lightText
        
        categoriesScrollView.backgroundColor = .lightText
        
        addCategories()
        
        categoriesScrollView.addSubview(rootFlexContainer)
        addSubview(categoriesScrollView)
    }
    
    fileprivate func addCategories(){
        if let categories = todoItemCategories {
            
            rootFlexContainer.subviews.forEach({ $0.removeFromSuperview() })
            
            for category in categories.reversed() {
                
                rootFlexContainer.flex.wrap(.wrap).direction(.row).alignContent(.stretch).define { (rootFlex) in
                    let categoryViewCell = CategoryViewCell()
                    categoryViewCell.configureView(category: category)
                    
                    rootFlex.addItem(categoryViewCell)
                }
                layout()
            }
        }
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    fileprivate func layout(){
        categoriesScrollView.pin.all(pin.safeArea)
        
        rootFlexContainer.pin.top().left().right()
        
        rootFlexContainer.flex.layout(mode: .adjustHeight)
        
        categoriesScrollView.contentSize = rootFlexContainer.frame.size
    }
    
    func addCategory(category: TodoItemCategory){
        rootFlexContainer.flex.wrap(.wrap).direction(.row).justifyContent(.start).define { (rootFlex) in
            let categoryViewCell = CategoryViewCell()
            categoryViewCell.configureView(category: category)
            
            rootFlex.addItem(categoryViewCell).marginBottom(5).marginTop(5)
            
            layout()
        }
    }
    
    func refreshCategories(_ categories:  [TodoItemCategory]) {
        self.todoItemCategories = categories
        addCategories()
    }
    
}
