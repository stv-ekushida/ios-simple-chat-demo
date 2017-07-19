//
//  MessageListTableViewCellTests.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import Foundation

import XCTest
@testable import ios_simple_chat_demo

class MessageListTableViewCellTests: XCTestCase {

    var tableView: UITableView!
    let dataSource = FakeDataSource()
    var cell: MessageListTableViewCell!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "MessageListViewController", bundle: nil)
        let controller = storyboard
            .instantiateViewController(
                withIdentifier: "MessageListViewController")
            as! MessageListViewController

        _ = controller.view

        tableView = controller.messageTableView
        tableView?.dataSource = dataSource

        cell = tableView?.dequeueReusableCell(
            withIdentifier: "MessageListTableViewCell",
            for: IndexPath(row: 0, section: 0)) as! MessageListTableViewCell

    }

    override func tearDown() {
        super.tearDown()
    }

    /// check: メッセージと日付が正しく表示されているか
    func testSetDateLabel_ForYYYYMMDD() {

        let message = Message()
        message.message = "あいうえおかきくけこ"
        message.updated = string2Date(dateString: "2015/10/10 10:10:10")
        cell.item = message

        XCTAssertEqual(cell.messageTextView.text, "あいうえおかきくけこ")
        XCTAssertEqual(cell.dateLabel.text, "10:10")
    }

    //MARK : - Helper
    private func string2Date(dateString: String) -> Date{

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.date(from: dateString)!
    }
}

extension MessageListTableViewCellTests {

    class FakeDataSource: NSObject, UITableViewDataSource {

        func tableView(_ tableView: UITableView,
                       numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
