//
//  Message.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import Foundation
import RealmSwift

final class Message: Object {

    dynamic var messageID = 0
    dynamic var message = ""
    dynamic var postDate = Date().now()

    override static func primaryKey() -> String? {
        return "messageID"
    }
}
