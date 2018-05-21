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
            
            categories.forEach { (category) in
                rootFlexContainer.flex.wrap(.wrap).direction(.row).alignContent(.stretch).define { (rootFlex) in
                    let categoryViewCell = CategoryViewCell()
                    
                    categoryViewCell.configureView(category: category)
                    rootFlex.addItem(categoryViewCell).grow(1).marginHorizontal(2.5).marginVertical(5)
                }
            }
            
            layout()
        }
    }
    
    fileprivate func resize(changedCell: CategoryViewCell){
        
        for aCell in rootFlexContainer.subviews {
            let cellToChange = aCell as! CategoryViewCell
            if cellToChange.todoItemCategory == changedCell.todoItemCategory {
                cellToChange.flex.height(changedCell.frame.size.height)
            }
        }
        
        layout()
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
        self.todoItemCategories?.append(category)
        addCategories()
    }
    
    func refreshCategories(_ categories:  [TodoItemCategory]) {
        self.todoItemCategories = categories
        addCategories()
    }
    
    func addNewCategoryCell(){
        
    }
    
}
