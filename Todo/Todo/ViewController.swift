//
//  ViewController.swift
//  Todo
//
//  Created by Jordan Christensen on 2/9/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Variables
    var keyboardSize = CGRect()
    var keyboardDismissTapGestureRecognizer: UITapGestureRecognizer!

    // MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissTapGestureRecognizer()
        textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Functions
    
}

// MARK: - Extensions
extension ViewController: UITextViewDelegate, UIGestureRecognizerDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        keyboardDismissTapGestureRecognizer.isEnabled = true
        
        if let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardSize = keyboardRect
        } else if let keyboardRect = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect {
            keyboardSize = keyboardRect
        }
        
        textViewHeight.constant -= keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        textViewHeight.constant = 0
        
        stopEditingTextInput()
    }
    
    @objc func stopEditingTextInput() {
        textView.resignFirstResponder()
        
        guard keyboardDismissTapGestureRecognizer.isEnabled else { return }
        keyboardDismissTapGestureRecognizer.isEnabled = false
    }
    
    @objc func setupKeyboardDismissTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopEditingTextInput))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(tapGestureRecognizer)
        keyboardDismissTapGestureRecognizer = tapGestureRecognizer
        
    }
}
