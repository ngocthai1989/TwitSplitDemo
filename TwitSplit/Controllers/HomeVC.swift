//
//  ViewController.swift
//  TwitSplit
//
//  Created by Thien Huynh on 3/31/18.
//  Copyright © 2018 Thien Huynh. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var newInputView: UIView!
    @IBOutlet weak var messagesTableView: UITableView!
    
    private var lstData: [MessageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        configEventListener()
    }
    
    private func configTableView() {
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.estimatedRowHeight = 44
    }
    
    private func reloadTableView(numOfInsert: Int) {
        // prepare list indexPaths to insert
        let lstIP = (0..<numOfInsert).map {IndexPath(row: $0, section: 0)}
        
        // insertRows with animation
        messagesTableView.beginUpdates()
        messagesTableView.insertRows(at: lstIP, with: UITableViewRowAnimation.automatic)
        messagesTableView.endUpdates()
        
        // scroll to top of table view to visible the newest data
        messagesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
    }
    
    private func configEventListener() {
        // add tap gesture to viewInput
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewInputDidTap(gesture:)))
        newInputView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func viewInputDidTap(gesture: UITapGestureRecognizer) {
        // config and present Input View Controller
        if let inputVC = UIStoryboard(name: Const.STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Const.VCTRL_INPUT_ID) as? InputVC {
            inputVC.delegate = self
            present(inputVC, animated: true, completion: nil)
        }
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Const.REUSE_MESSAGE_CELL) as? MessageCell {
            cell.updateCell(message: lstData[indexPath.row].content)
            return cell
        }
        return MessageCell(style: .default, reuseIdentifier: Const.REUSE_MESSAGE_CELL)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension HomeVC: InputVCDelegate {
    func didInput(messages: [String]) {
        // insert new data to lstData
        messages.reversed().forEach {
            lstData.insert(MessageData(content: $0), at: 0)
        }
        
        // reload tableView to show new data
        reloadTableView(numOfInsert: messages.count)
    }
}
