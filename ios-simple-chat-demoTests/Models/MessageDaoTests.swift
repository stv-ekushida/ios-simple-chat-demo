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
        MessageDao.deleteAll()        
    }
    
    override func tearDown() {
        super.tearDown()
        MessageDao.deleteAll()
    }
    
    /// check: メッセージが登録できているか？
    func testAddMessage() {

        MessageDao.add(message: "テスト")
        let messages = MessageDao.findAll()
        XCTAssertEqual("テスト", messages.first?.message)
    }

    /// check : 複数メッセージが登録できているか？
    func testAddMessage_MultiMessages() {

        MessageDao.add(message: "テスト1")
        MessageDao.add(message: "テスト2")

        let messages = MessageDao.findAll()
        XCTAssertEqual("テスト1", messages.first?.message)
        XCTAssertEqual("テスト2", messages.last?.message)
    }

    /// check : 日付ごとにグルーピングできているか？
    func testGroupByPostDate() {

        MessageDao.add(message: "あいうえお", updated: string2Date(dateString: "2017/10/10 10:10:10"))
        MessageDao.add(message: "かきくけこ", updated: string2Date(dateString: "2017/10/09 10:10:10"))
        MessageDao.add(message: "うえだしんや", updated: string2Date(dateString: "2017/10/10 10:10:10"))
        
        let messages = MessageDao.groupByPostDate()

        XCTAssertTrue(messages.count == 2)
        XCTAssertEqual("2017-10-10", messages.first)
        XCTAssertEqual("2017-10-09", messages.last)
    }

    /// 該当日付のメッセージが取得できるか？
    func testFindByPostDate() {

        MessageDao.add(message: "あいうえお", updated: string2Date(dateString: "2017/10/10 10:10:10"))
        MessageDao.add(message: "かきくけこ", updated: string2Date(dateString: "2017/10/09 10:10:10"))
        MessageDao.add(message: "うえだしんや", updated: string2Date(dateString: "2017/10/10 10:10:10"))

        let messages = MessageDao.findBy(postDate: "2017/10/10")

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
