//
//  MessageListProvider.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

final class MessageListProvider: NSObject {

    fileprivate var messages: [Message] = []

    /// メッセージの一覧を設定する
    ///
    /// - Parameter messages: メッセージ一覧
    func setMessages(messages: [Message]) {
        self.messages = messages
    }

    /// 該当のメッセージを取得する
    ///
    /// - Parameter index: TableViewのインデックス
    /// - Returns: メッセージ
    func message(index: Int) -> Message {

        guard index < messages.count else {
            fatalError("messagesの要素数を超えました。")
        }
        return messages[index]
    }

    /// メッセージの数を取得する
    ///
    /// - Returns: メッセージ数
    func count() -> Int {
        return messages.count
    }
}

//MARK : - UITableViewDataSource
extension MessageListProvider: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView
            .dequeueReusableCell(withIdentifier: MessageListTableViewCell.identifier,
                                 for: indexPath) as? MessageListTableViewCell
        cell?.item = message(index: indexPath.row)
        return cell!
    }
}
