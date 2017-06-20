//
//  MessageListProvider.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

final class MessageListProvider: NSObject {

    fileprivate var messageGroups: [String] = []
    fileprivate var messages: [[Message]] = []

    /// メッセージグループの一覧を設定する
    ///
    /// - Parameter groups: メッセージグループの一覧
    func setMessageGroup(groups: [String]) {
        self.messageGroups = groups
    }

    /// メッセージの一覧を設定する
    ///
    /// - Parameters:
    ///   - index: メッセージグループのインデックス
    ///   - messages: メッセージ一覧
    func setMessages(index: Int, messages: [Message]) {

        if self.messages.count - 1  < index {
            self.messages.append(messages)
        } else {
            self.messages[index] = messages
        }
    }

    /// 該当のメッセージを取得する
    ///
    /// - Parameter index: TableViewのインデックス
    /// - Returns: メッセージ
    func message(section: Int, index: Int) -> Message {
        return messages[section][index]
    }
}

//MARK : - UITableViewDataSource
extension MessageListProvider: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return messageGroups.count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return messageGroups[section]
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView
            .dequeueReusableCell(withIdentifier: MessageListTableViewCell.identifier,
                                 for: indexPath) as? MessageListTableViewCell
        cell?.item = message(section: indexPath.section, index: indexPath.row)
        return cell!
    }
}
