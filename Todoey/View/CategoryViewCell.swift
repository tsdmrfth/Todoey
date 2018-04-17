//
//  CategoryViewCell.swift
//  Todoey
//
//  Created by Fatih Tasdemir on 17.04.2018.
//  Copyright © 2018 Fatih Tasdemir. All rights reserved.
//

import UIKit
import PinLayout
import ChameleonFramework

class CategoryViewCell: UIView {
    
    fileprivate let label = UILabel()
    fileprivate let frameView = UIView()
    fileprivate let deleteButton = UIButton(type: .custom)
    fileprivate let editButton = UIButton(type: .custom)
    fileprivate let buttonsView = UIView()
    fileprivate var isButtonsHidden: Bool = true
    
    init() {
        super.init(frame: .zero)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initializeView(){
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = label.font.withSize(22)
        
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        deleteButton.addTarget(self, action: #selector(self.onDeleteButtonClicked), for: .touchUpInside)
        deleteButton.alpha = 0
        
        editButton.setImage(UIImage(named: "edit"), for: .normal)
        editButton.addTarget(self, action: #selector(self.onEditButtonClicked), for: .touchUpInside)
        editButton.alpha = 0
        
        let frameViewTapGesture = UITapGestureRecognizer(target: self, action:  #selector(CategoryViewCell.onFrameViewClicked))
        frameView.addGestureRecognizer(frameViewTapGesture)
        
        frameView.addSubview(buttonsView)
        frameView.addSubview(label)
        addSubview(frameView)
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    fileprivate func layout(){
        frameView.flex.margin(5).maxWidth(180).minWidth(100)
        
        buttonsView.flex.alignSelf(.end).marginTop(10).marginHorizontal(10).direction(.row).define { (flex) in
            flex.addItem(editButton).size(15).marginRight(10)
            flex.addItem(deleteButton).size(15)
        }

        label.flex.alignSelf(.auto).paddingEnd(5).paddingTop(40)
        
        frameView.layer.cornerRadius = 10
        frameView.clipsToBounds = true
    }
    
    func configureView(category: TodoItemCategory){
        frameView.backgroundColor = UIColor(hexString: category.colour)
        
        label.textColor = ContrastColorOf(UIColor(hexString: category.colour)!, returnFlat: true)
        label.text = category.categoryName + " merhababasdsd mwrhaba"
        
        editButton.tintColor = ContrastColorOf(UIColor(hexString: category.colour)!, returnFlat: true)
        deleteButton.tintColor = ContrastColorOf(UIColor(hexString: category.colour)!, returnFlat: true)
        
        frameView.layer.cornerRadius = 5
        
        layout()
    }
    
    @objc fileprivate func onDeleteButtonClicked(){
        print("onDeleteButtonClicked")
    }
    
    @objc fileprivate func onEditButtonClicked(){
        print("onEditButtonClicked")
    }
    
    @objc func onFrameViewClicked(){
        showButtons()
    }
    
    fileprivate func showButtons(){
        if isButtonsHidden {
            isButtonsHidden = false
            UIView.animate(withDuration: 0.8) {
                self.editButton.alpha = 1
                self.deleteButton.alpha = 1
            }
        } else {
            isButtonsHidden = true
            UIView.animate(withDuration: 0.8) {
                self.editButton.alpha = 0
                self.deleteButton.alpha = 0
            }
        }
        
    }
    
}
