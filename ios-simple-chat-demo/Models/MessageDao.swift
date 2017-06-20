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
        MessageDao.dao.add(d: message)
    }

    /// メッセージ名で検索する
    ///
    /// - Parameter message: メッセージ
    /// - Returns: メッセージ一覧
    static func findByMessage(message: String) -> [Message] {

        let results = MessageDao.dao
            .findAll()
            .filter("message CONTAINS %@", message)
        return results.map { Message(value: $0) }
    }

    /// 投稿日で検索する
    ///
    /// - Parameter date: 日付
    /// - Returns: メッセージ一覧
    static func findByPostDate(date: String) -> [Message] {

        let fromDate = "\(date) 00:00:00".toDateStyleMedium(dateFormat: "yyyy-MM-dd HH:mm:ss")
        let toDate = "\(date) 23:59:59".toDateStyleMedium(dateFormat: "yyyy-MM-dd HH:mm:ss")

        let results = MessageDao.dao
            .findAll()
            .filter("postDate >= %@ AND postDate <= %@", fromDate, toDate)
        return results.map { Message(value: $0) }
    }

    /// 投稿日ごとに集計する
    ///
    /// - Returns: メッセージ一覧
    static func groupByPostDate() -> [String] {

        let messages = MessageDao.dao.findAll()
        var results: [String] = []

        for message in messages {

            let postDate = message.postDate
                .description.components(separatedBy: " ").first

            if (results.filter { $0 == postDate }.count > 0) {
                continue
            }
            results.append(postDate!)
        }
        return results
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
