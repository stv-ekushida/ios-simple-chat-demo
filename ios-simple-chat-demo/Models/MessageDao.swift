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
    /// - Parameter message: メッセージ
    static func add(_ message: String) {

        let object = Message()
        object.messageID = dao.newId()!
        object.message = message
        object.updated = Date().now()
        dao.add(d: object)
    }

    /// 投稿日で検索する
    ///
    /// - Parameter date: 日付
    /// - Returns: メッセージ一覧
    static func findByPostDate(_ date: String) -> [Message] {

        let fromDate = "\(date) 00:00:00".toDateStyleMedium(dateFormat: "yyyy-MM-dd HH:mm:ss")
        let toDate = "\(date) 23:59:59".toDateStyleMedium(dateFormat: "yyyy-MM-dd HH:mm:ss")

        return dao.findAll()
            .filter("updated >= %@ AND updated <= %@", fromDate, toDate)
            .map { Message(value: $0) }
    }

    /// 投稿日ごとに集計する
    ///
    /// - Returns: メッセージ一覧
    static func groupByPostDate() -> [String] {

        let messages = MessageDao.dao.findAll()
        var results = [String]()

        for message in messages {

            guard let postDate = message.updated
                .description.components(separatedBy: " ").first else {
                    continue
            }

            if (results.filter { $0 == postDate }.count > 0) {
                continue
            }
            results.append(postDate)
        }
        return results
    }

    /// メッセージ一覧を取得する（降順）
    ///
    /// - Returns: メッセージ一覧
    static func findAll() -> [Message] {
        return dao.findAll()
            .sorted(byKeyPath: "updated", ascending: true)
            .map { Message(value: $0) }
    }

    /// メッセージをすべて削除する
    static func deleteAll() {
        dao.deleteAll()
    }
}
