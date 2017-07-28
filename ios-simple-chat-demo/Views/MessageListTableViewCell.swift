//
//  MessageListTableViewCell.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

final class MessageListTableViewCell: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var messageTextView: UITextView!    
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Properties
    private struct Const {
        static let margin: CGFloat = 10
    }

    static var identifier: String {
        return String(describing: self)
    }

    var item: Message? {

        didSet {
            setup()
            messageTextView.text = item?.message
            dateLabel.text = item?.postData
        }
    }
    
    private func setup() {
        messageTextView.textContainerInset =
            UIEdgeInsetsMake(Const.margin, Const.margin, Const.margin, Const.margin)
        messageTextView.sizeToFit()
    }
}
