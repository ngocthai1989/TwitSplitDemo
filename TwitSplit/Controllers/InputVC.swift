//
//  InputVC.swift
//  TwitSplit
//
//  Created by Thien Huynh on 4/1/18.
//  Copyright © 2018 Thien Huynh. All rights reserved.
//

import UIKit

class InputVC: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    private let PLACEHOLDER_TEXT = "Your Message..."
    private let PLACEHOLDER_COLOR = UIColor.lightGray
    private let DEFAULT_COLOR = UIColor.black
    
    private var placeholderLabel: UILabel!
    var delegate: InputVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextView()
        
        // set share button to disable because the input is empty
        shareButton.isEnabled = false
    }

    private func configTextView() {
        inputTextView.delegate = self
        inputTextView.becomeFirstResponder()
        setupTextViewPlaceholder()
        addLabelCharacterCounter()
    }
    
    private func setupTextViewPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.font = inputTextView.font
        placeholderLabel.textColor = PLACEHOLDER_COLOR
        placeholderLabel.text = PLACEHOLDER_TEXT
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (inputTextView.font?.pointSize ?? 17) / 2)
        placeholderLabel.isHidden = false
        
        inputTextView.addSubview(placeholderLabel)
    }
    
    private func addLabelCharacterCounter() {
        let accessoryView = UIView()
        accessoryView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        accessoryView.backgroundColor = UIColor.groupTableViewBackground
        
        let counterLabel  = UILabel()
        counterLabel.text = "0"
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.addSubview(counterLabel)
        
        // setup contraint
        accessoryView.trailingAnchor.constraint(equalTo: counterLabel.trailingAnchor, constant: 20).isActive = true
        accessoryView.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor).isActive = true
        
        // add accessoryView to text view
        inputTextView.inputAccessoryView = accessoryView
    }
    
    @IBAction func buttonCancelDidTouch(_ sender: UIBarButtonItem) {
        inputTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonShareDidTouch(_ sender: UIBarButtonItem) {
        if let input = inputTextView.text, !input.isEmpty {
            let splitMsg = Util.splitMessage(input)
            
            if splitMsg.isEmpty {
                showErrorAlert()
                
            } else {
                inputTextView.resignFirstResponder()
                dismiss(animated: true) { [weak self] in
                        self?.delegate?.didInput(messages: splitMsg)
                }
                
            }
        }
    }
    
    private func showErrorAlert() {
        let alertCtrl = UIAlertController(title: Const.ALERT_TITLE_ERROR, message: Const.ALERT_MESSAGE_INVALID_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: Const.ALERT_BUTTON_DISMISS, style: UIAlertActionStyle.default, handler: {
            action in
            self.inputTextView.selectedTextRange = self.inputTextView.textRange(from: self.inputTextView.beginningOfDocument , to: self.inputTextView.endOfDocument)
        })
        alertCtrl.addAction(dismissAction)
        
        present(alertCtrl, animated: true, completion: nil)
    }
}

extension InputVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // check if button share should be disable
        shareButton.isEnabled = !textView.text.isEmpty
        
        // check if placeholderLabel should be visible or not
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // set value for label character counter
        if let lblCounter = textView.inputAccessoryView?.subviews.filter({$0 is UILabel}).first as? UILabel{
            lblCounter.text = "\(textView.text.count)"
        }
    }
}

protocol InputVCDelegate {
    func didInput(messages: [String])
}
