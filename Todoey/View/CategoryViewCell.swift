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
import SwiftEventBus
import Foundation

class CategoryViewCell: UIView {
    
    fileprivate let frameView = UIView()
    fileprivate let saveButton = UIButton(type: .custom)
    fileprivate let deleteButton = UIButton(type: .custom)
    fileprivate let editButton = UIButton(type: .custom)
    fileprivate let textView = UITextView()
    fileprivate let dateLabel = UILabel()
    fileprivate let buttonsView = UIView()
    fileprivate var isButtonsHidden: Bool = true
    
    fileprivate var todoItemCategory: TodoItemCategory!
    
    init() {
        super.init(frame: .zero)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initializeView(){
        saveButton.setImage(UIImage(named: "save"), for: .normal)
        saveButton.addTarget(self, action: #selector(self.onSaveButtonClicked), for: .touchUpInside)
        saveButton.alpha = 0
        
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        deleteButton.addTarget(self, action: #selector(self.onDeleteButtonClicked), for: .touchUpInside)
        deleteButton.alpha = 0
        
        editButton.setImage(UIImage(named: "edit"), for: .normal)
        editButton.addTarget(self, action: #selector(self.onEditButtonClicked), for: .touchUpInside)
        editButton.alpha = 0
        
        textView.font = UIFont.systemFont(ofSize: 22)
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.delegate = self
        
        dateLabel.font = .systemFont(ofSize: 9)
        
        let frameViewTapGesture = UITapGestureRecognizer(target: self, action:  #selector(CategoryViewCell.onFrameViewClicked))
        frameView.addGestureRecognizer(frameViewTapGesture)
        
        let textViewTapGesture = UITapGestureRecognizer(target: self, action:  #selector(CategoryViewCell.onFrameViewClicked))
        textView.addGestureRecognizer(textViewTapGesture)
        
        frameView.addSubview(buttonsView)
        frameView.addSubview(textView)
        frameView.addSubview(dateLabel)
        addSubview(frameView)
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    fileprivate func layout(){
        frameView.flex.margin(5).maxWidth(180).minWidth(100)
        
        buttonsView.flex.alignSelf(.center).marginTop(10).direction(.row).define { (flex) in
            flex.addItem(saveButton).size(20)
            flex.addItem(editButton).size(20).marginLeft(25)
            flex.addItem(deleteButton).size(20).marginLeft(25)
        }
        
        dateLabel.flex.alignSelf(.end).marginBottom(5).marginRight(5)
        
        textView.flex.alignSelf(.auto).paddingEnd(5).paddingTop(40).paddingBottom(15)
        
        frameView.layer.cornerRadius = 10
        frameView.clipsToBounds = true
    }
    
    func configureView(category: TodoItemCategory){
        self.todoItemCategory = category
        frameView.backgroundColor = UIColor(hexString: category.colour)
        
        editButton.tintColor = ContrastColorOf(UIColor(hexString: category.colour)!, returnFlat: true)
        deleteButton.tintColor = ContrastColorOf(UIColor(hexString: category.colour)!, returnFlat: true)
        saveButton.tintColor = ContrastColorOf(UIColor(hexString: category.colour)!, returnFlat: true)
        
        textView.text = category.categoryName
        textView.textColor = ContrastColorOf(UIColor(hexString: category.colour)!, returnFlat: true)
        
        dateLabel.text = category.createDate
        dateLabel.textColor = ContrastColorOf(UIColor(hexString: category.colour)!, returnFlat: true)
        
        frameView.layer.cornerRadius = 5
        
        layout()
    }
    
    @objc fileprivate func onSaveButtonClicked(){
        UIView.animate(withDuration: 0.8, animations: {
            self.toggleButtonsAlpha()
        }) { (process) in
            if process {
                SwiftEventBus.post(Constant.onSaveButtonClicked,
                                   sender: SaveButtonEvent(item: self.todoItemCategory,
                                                           itemProperty: self.textView.text))
            }
        }
    }
    
    @objc fileprivate func onDeleteButtonClicked(){
        UIView.animate(withDuration: 0.8, animations: {
            self.frameView.alpha = 0
        }) { (process) in
            if process {
                SwiftEventBus.post(Constant.onDeleteButtonClicked, sender: DeleteButtonEvent(item: self.todoItemCategory))
            }
        }
    }
    
    @objc fileprivate func onEditButtonClicked(){
        textView.isEditable = true
        textView.becomeFirstResponder()
    }
    
    @objc func onFrameViewClicked(){
        toggleButtonsAlpha()
        textView.isEditable = false
        textView.resignFirstResponder()
    }
    
    fileprivate func toggleButtonsAlpha(){
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
    
    fileprivate func changeSaveButtonAlpha(to: CGFloat){
        UIView.animate(withDuration: 0.8) {
            self.saveButton.alpha = to
        }
    }
    
}

extension CategoryViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        changeSaveButtonAlpha(to: 1)
    }
    
}


