//
//  MessageDao.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import Foundation
import RealmSwift
import STV_Extensions

final class MessageDao {

    static let dao = RealmDaoHelper<Message>()

    /// メッセージを追加する
    ///
    /// - Parameter model: メッセージ
    static func add(model: Message) {

        let message = Message()
        message.messageID = MessageDao.dao.newId()!
        message.message = model.message
        message.postDate = Date().now()
        MessageDao.dao.add(d: message)
    }

    /// メッセージ名で検索する
    ///
    /// - Parameter message: メッセージ
    /// - Returns: 一致したメッセージ一覧
    static func findByMessage(message: String) -> [Message] {

        let result = MessageDao.dao
            .findAll()
            .filter("message CONTAINS %@", message)
        return result.map { Message(value: $0) }
    }

    /// メッセージ一覧を取得する（降順）
    ///
    /// - Returns: メッセージ一覧
    static func findAll() -> [Message] {
        let result = MessageDao.dao
            .findAll()
            .sorted(byKeyPath: "postDate", ascending: true)
        return result.map { Message(value: $0) }
    }

    /// メッセージをすべて削除する
    static func deleteAll() {
        dao.deleteAll()
    }
}
