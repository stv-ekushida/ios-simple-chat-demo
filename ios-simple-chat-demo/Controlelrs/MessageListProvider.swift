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
    /// - Parameter messages: メッセージ一覧
    func setMessages(messages: [Message]) {
        self.messages.append(messages)
    }

    /// 該当のメッセージを取得する
    ///
    /// - Parameter index: TableViewのインデックス
    /// - Returns: メッセージ
    func message(section: Int, index: Int) -> Message {

        guard section < messageGroups.count else {
            fatalError("sectionsの要素数を超えました。")
        }

        guard index < messages[section].count else {
            fatalError("messagesの要素数を超えました。")
        }
        return messages[section][index]
    }

    /// メッセージの数を取得する
    ///
    /// - Returns: メッセージ数
    func count(section: Int) -> Int {
        return messages[section].count
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
