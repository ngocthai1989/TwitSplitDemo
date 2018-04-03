//
//  InputVC.swift
//  TwitSplit
//
//  Created by Thien Huynh on 4/1/18.
//  Copyright © 2018 Thien Huynh. All rights reserved.
//

import UIKit

class InputVC: UIViewController {

    @IBOutlet weak var textViewInput: UITextView!
    
    private let PLACEHOLDER_TEXT = "Your Message..."
    private let PLACEHOLDER_COLOR = UIColor.lightGray
    private let DEFAULT_COLOR = UIColor.black
    
    private var placeholderLabel: UILabel!
    var delegate: InputVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextView()
    }

    private func configTextView() {
        textViewInput.delegate = self
        textViewInput.becomeFirstResponder()
        setupTextViewPlaceholder()
        addLabelCharacterCounter()
    }
    
    private func setupTextViewPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.font = textViewInput.font
        placeholderLabel.textColor = PLACEHOLDER_COLOR
        placeholderLabel.text = PLACEHOLDER_TEXT
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textViewInput.font?.pointSize ?? 17) / 2)
        placeholderLabel.isHidden = false
        
        textViewInput.addSubview(placeholderLabel)
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
        textViewInput.inputAccessoryView = accessoryView
    }
    
    @IBAction func buttonCancelDidTouch(_ sender: UIBarButtonItem) {
        textViewInput.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonShareDidTouch(_ sender: UIBarButtonItem) {
        if let input = textViewInput.text, !input.isEmpty {
            let splitMsg = Util.splitMessage(input)
            
            if splitMsg.isEmpty {
                print("Error")
                
            } else {
                textViewInput.resignFirstResponder()
                dismiss(animated: true) { [weak self] in
                        self?.delegate?.didInput(messages: splitMsg)
                }
                
            }
        }
    }
    
}

extension InputVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
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
