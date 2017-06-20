//
//  MessageDaoTests.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import XCTest
@testable import ios_simple_chat_demo

class MessageDaoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        MessageDao.deleteAll()
    }
    
    /// check: メッセージが登録できているか？
    func testAddMessage() {

        let message = Message()
        message.message = "テスト"
        MessageDao.add(model: message)

        let messages = MessageDao.findAll()
        XCTAssertEqual("テスト", messages.first?.message)
    }

    /// check : 複数メッセージが登録できているか？
    func testAddMessage_MultiMessages() {

        let message1 = Message()
        message1.message = "テスト1"
        MessageDao.add(model: message1)

        let message2 = Message()
        message2.message = "テスト2"
        MessageDao.add(model: message2)

        let messages = MessageDao.findAll()
        XCTAssertEqual("テスト1", messages.first?.message)
        XCTAssertEqual("テスト2", messages.last?.message)
    }

    /// check : 「う」で検索できるか？
    func testFindMessage_Like_For_U() {

        let message1 = Message()
        message1.message = "あいうえお"
        MessageDao.add(model: message1)

        let message2 = Message()
        message2.message = "かきくけこ"
        MessageDao.add(model: message2)

        let message3 = Message()
        message3.message = "うえだしんや"
        MessageDao.add(model: message3)

        let messages = MessageDao.findByMessage(message: "う")
        XCTAssertEqual("あいうえお", messages.first?.message)
        XCTAssertEqual("うえだしんや", messages.last?.message)
    }

    /// check : 「うえだ」で検索できるか？
    func testFindMessage_Like_For_Ueda() {

        let message1 = Message()
        message1.message = "あいうえお"
        MessageDao.add(model: message1)

        let message2 = Message()
        message2.message = "かきくけこ"
        MessageDao.add(model: message2)

        let message3 = Message()
        message3.message = "うえだしんや"
        MessageDao.add(model: message3)

        let messages = MessageDao.findByMessage(message: "うえだ")
        XCTAssertEqual("うえだしんや", messages.first?.message)
    }

    /// check : 日付ごとにグルーピングできているか？
    func testGroupByPostDate() {

        let message1 = Message()
        message1.message = "あいうえお"
        message1.postDate = string2Date(dateString: "2017/10/10 10:10:10")
        MessageDao.add(model: message1)

        let message2 = Message()
        message2.message = "かきくけこ"
        message2.postDate = string2Date(dateString: "2017/10/09 10:10:10")
        MessageDao.add(model: message2)

        let message3 = Message()
        message3.message = "うえだしんや"
        message3.postDate = string2Date(dateString: "2017/10/10 10:10:10")
        MessageDao.add(model: message3)

        let messages = MessageDao.groupByPostDate()

        XCTAssertTrue(messages.count == 2)

        XCTAssertEqual("2017-10-10", messages.first)
        XCTAssertEqual("2017-10-09", messages.last)
    }

    /// 該当日付のメッセージが取得できるか？
    func testFindByPostDate() {

        let message1 = Message()
        message1.message = "あいうえお"
        message1.postDate = string2Date(dateString: "2017/10/10 10:10:10")
        MessageDao.add(model: message1)

        let message2 = Message()
        message2.message = "かきくけこ"
        message2.postDate = string2Date(dateString: "2017/10/09 10:10:10")
        MessageDao.add(model: message2)

        let message3 = Message()
        message3.message = "うえだしんや"
        message3.postDate = string2Date(dateString: "2017/10/10 10:10:10")
        MessageDao.add(model: message3)

        let messages = MessageDao.findByPostDate(date: "2017/10/10")

        XCTAssertTrue(messages.count == 2)

        XCTAssertEqual("あいうえお", messages.first?.message)
        XCTAssertEqual("うえだしんや", messages.last?.message)
    }

    //MARK : - Helper
    private func string2Date(dateString: String) -> Date{

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.date(from: dateString)!
    }

}
