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
    let marginMessageTextView: CGFloat = 10

    static var identifier: String {
        return String(describing: self)
    }

    var item: Message? {

        didSet {

            messageTextView.text = item?.message
            dateLabel.text = item?.postData
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setup() {
        
        messageTextView.textContainerInset =
            UIEdgeInsetsMake(marginMessageTextView,
                             marginMessageTextView,
                             marginMessageTextView,
                             marginMessageTextView)
        messageTextView.sizeToFit()
    }
}
