//
//  MessageListTableViewCell.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

final class MessageListTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    /// メッセージ
    var item: Message? {

        didSet {

            messageTextView.text = item?.message
            messageTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
            messageTextView.sizeToFit()

            if let date = item?.postDate {
                dateLabel.text = dateStyle(date: date)
            }
        }
    }

    /// 日付のフォーマット
    ///
    /// - Parameter date: 日付
    /// - Returns: HH : MM
    func dateStyle(date: Date) -> String {

        let calendar = Calendar.current
        let components = calendar
            .dateComponents([.year, .month, .day, .hour, .minute],
                            from: date)

        if let hour = components.hour,
        let minite = components.minute {
            return String(format: "%02d:%02d",hour, minite)
        }
        return ""
    }
}
