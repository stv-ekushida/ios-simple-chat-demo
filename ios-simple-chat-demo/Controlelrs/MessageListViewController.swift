//
//  MessageListViewController.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

final class MessageListViewController: UIViewController {

    @IBOutlet weak var messageTableView: UITableView!
    let dataSource = MessageListProvider()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMessageList()
    }

    private func setup() {
        messageTableView.dataSource = dataSource
    }

    /// メッセージ一覧の表示
    private func reloadMessageList() {

        let groups = MessageDao.groupByPostDate()
        dataSource.setMessageGroup(groups: groups)

        for gropu in groups {

            let messages = MessageDao.findByPostDate(date: gropu)
            dataSource.setMessages(messages: messages)
        }
        messageTableView.reloadData()
        messageTableView.scrollToBottom()
    }
}
