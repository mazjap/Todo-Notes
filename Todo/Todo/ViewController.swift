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
    private var wordCountBarButton: UIBarButtonItem?
    private var keyboardSize = CGRect()
//    private var keyboardDismissTapGestureRecognizer: UISwipeGestureRecognizer!
    private let notesController = NotesController()
    private let fonts = [UIFont(name: "Hiragino Sans W6", size: 18), UIFont(name: "Khmer Sangam MN", size: 18), UIFont(name: "Arial Rounded MT Bold", size: 18), UIFont(name: "Noteworthy Bold", size: 18), UIFont(name: "American Typewriter", size: 18), UIFont(name: "Copperplate", size: 18)]

    // MARK: - IBOutlets
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewHeight: NSLayoutConstraint!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.endEditing(true)
        textView.endEditing(true)
        load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        save()
        view.endEditing(true)
        textView.endEditing(true)
    }
    
    // MARK: - Functions
    private func setUp() {
        textView.delegate = self
        textView.keyboardDismissMode = .interactive
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        setupKeyboardDismissTapGestureRecognizer()
    }
    
    public func save() {
        notesController.saveNotesToPersistantStore(textView.text)
        guard let font = textView.font else { return }
        notesController.saveFontToPersistantStore(font.fontName)
    }
    
    public func load() {
        textView.text = notesController.loadNotesFromPersistantStore()
        if let fontName = notesController.loadFontFromPersistantStore() {
            textView.font = UIFont(name: fontName, size: 18)
        } else {
            textView.font = fonts.first!
        }
    }
    
    override var inputAccessoryView: UIView? {
        textView
    }
}

// MARK: - Extensions
extension ViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setupTextViewsAccessoryView()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let _ = textView.inputAccessoryView, let button = wordCountBarButton else {
            setupTextViewsAccessoryView()
            return
        }
        button.title = getWordCount()
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func getWordCount() -> String {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = textView.text.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        
        return "\(words.count) words"
    }
    
    func setupTextViewsAccessoryView() {
        if textView.inputAccessoryView == nil {
            let toolBar: UIToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
                toolBar.isTranslucent = true
            
            let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                target: nil,
                action: nil)
            
            let fontButton: UIBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "textformat.size"),
                landscapeImagePhone: nil,
                style: .plain,
                target: nil, action:
                #selector(fontPressed))
            
            let undoButton: UIBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "arrow.turn.up.left"),
                landscapeImagePhone: nil,
                style: .plain,
                target: nil,
                action: #selector(undoPressed))
            
            let copyButton: UIBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "paperclip.circle"),
                landscapeImagePhone: nil,
                style: .plain,
                target: nil,
                action: #selector(copyPressed))
            
            wordCountBarButton = UIBarButtonItem(title: getWordCount(), style: .plain, target: nil, action: nil)
            wordCountBarButton!.tintColor = UIColor.gray
            
            toolBar.items = [wordCountBarButton!, copyButton, flexsibleSpace, undoButton, fontButton]
            textView.inputAccessoryView = toolBar
        } else {
            textView.inputAccessoryView?.reloadInputViews()
        }
    }
    
    @objc
    func fontPressed() {
        guard let currentFont = textView.font,
            let fontIndex = fonts.firstIndex(of: currentFont) else {
            textView.font = fonts.first!
            return
        }
        
        textView.font = fonts[(fontIndex + 1) % fonts.count]
        
        save()
    }
    
    @objc
    func undoPressed() {
        textView.undoManager?.undo()
    }
    
    @objc
    func copyPressed() {
        UIPasteboard.general.string = textView.text
    }
}


extension ViewController: UIGestureRecognizerDelegate {
    @objc
    private func keyboardWillShow(notification: Notification) {
//        keyboardDismissTapGestureRecognizer.isEnabled = true
        
        if let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardSize = keyboardRect
        } else if let keyboardRect = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect {
            keyboardSize = keyboardRect
        }
        
        textViewHeight.constant -= keyboardSize.height - 40
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        textViewHeight.constant = 0
        
        stopEditingTextInput()
    }
    
    @objc
    private func stopEditingTextInput() {
        textView.resignFirstResponder()
        save()
        
//        guard keyboardDismissTapGestureRecognizer.isEnabled else { return }
//        keyboardDismissTapGestureRecognizer.isEnabled = false
//    }
    
//    @objc
//    private func setupKeyboardDismissTapGestureRecognizer() {
//        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(stopEditingTextInput))
//        swipeGestureRecognizer.numberOfTouchesRequired = 1
//        swipeGestureRecognizer.direction = .down
//
//        view.addGestureRecognizer(swipeGestureRecognizer)
//        keyboardDismissTapGestureRecognizer = swipeGestureRecognizer
//
    }
}
