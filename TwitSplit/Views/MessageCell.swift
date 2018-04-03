//
//  MessageCell.swift
//  TwitSplit
//
//  Created by Thien Huynh on 4/1/18.
//  Copyright © 2018 Thien Huynh. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var viewWarpper: UIView!
    @IBOutlet weak var labelContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewWarpper.layer.borderWidth = 1
//        viewWarpper.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawShadow()
    }
    
    private func drawShadow() {
        viewWarpper.layer.cornerRadius = 8
        viewWarpper.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewWarpper.layer.shadowRadius = 2
        viewWarpper.layer.shadowOpacity = 0.5
        
    }

    func updateCell(message: String) {
        labelContent.text = message
    }
}
