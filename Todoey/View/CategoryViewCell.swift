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
    var todoItemCategory: TodoItemCategory!
    
    init() {
        super.init(frame: .zero)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initializeView(){
        saveButton.setImage(UIImage(named: Constant.save), for: .normal)
        saveButton.addTarget(self, action: #selector(self.onSaveButtonClicked), for: .touchUpInside)
        saveButton.alpha = 0
        
        deleteButton.setImage(UIImage(named: Constant.delete), for: .normal)
        deleteButton.addTarget(self, action: #selector(self.onDeleteButtonClicked), for: .touchUpInside)
        deleteButton.alpha = 0
        
        editButton.setImage(UIImage(named: Constant.edit), for: .normal)
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
        frameView.flex.maxWidth(180).minWidth(100).marginBottom(10)
        
        buttonsView.flex.alignSelf(.center).marginTop(10).direction(.row).define { (flex) in
            flex.addItem(saveButton).size(20)
            flex.addItem(editButton).size(20).marginLeft(25)
            flex.addItem(deleteButton).size(20).marginLeft(25)
        }
        
        dateLabel.pin.bottom(5)
        dateLabel.flex.alignSelf(.end).marginRight(5)
    
        textView.pin.height(of: frameView).width(of: frameView)
        textView.flex.paddingEnd(5).paddingTop(40)
        
        frameView.layer.cornerRadius = 5
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
        
        dateLabel.text = category.createDate.toString(format: "EEE, dd MM yyyy HH:mm")
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
            
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.editButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }) { (process) in
                UIView.animate(withDuration: 0.5, animations: {
                  self.editButton.transform = CGAffineTransform(rotationAngle: 0)
                })
            }
            
            deleteButton.shake()
            
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
    
    fileprivate func adjustTextViewHeight() {
        let fixedWidth = textView.frame.size.width
        
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let difference = newSize.height - 35
        
        self.frameView.pin.height(84 + difference)
        
        layout()
    }
    
}

extension CategoryViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        changeSaveButtonAlpha(to: 1)
        adjustTextViewHeight()
    }
    
}


