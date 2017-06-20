//
//  MessageListViewController.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

private extension Selector {
    static let keyboardWillShow = #selector(MessageListViewController.keyboardWillShow(notification:))
    static let keyboardWillHide = #selector(MessageListViewController.keyboardWillHide(notification:))
}

final class MessageListViewController: UIViewController {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var constraintTextViewHeight: NSLayoutConstraint!

    private let dataSource = MessageListProvider()
    private var isObserving = false

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMessageList()
        addKeyboardShowHideEvent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardShowHideEvent()
    }

    //MARK:-Actions
    @IBAction func didTapSendButton(_ sender: UIButton) {

        let message = Message()
        message.message = inputTextView.text
        MessageDao.add(model: message)

        reloadMessageList()
        setupTextView()
    }
    
    private func setup() {

        messageTableView.estimatedRowHeight = 66
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.dataSource = dataSource

        inputTextView.delegate = self
        sendButton.isEnabled = false
    }

    /// メッセージ一覧の表示
    private func reloadMessageList() {

        let groups = MessageDao.groupByPostDate()
        dataSource.setMessageGroup(groups: groups)

        for (i,group) in groups.enumerated() {

            let messages = MessageDao.findByPostDate(date: group)
            dataSource.setMessages(index: i, messages: messages)
        }
        messageTableView.reloadData()
        messageTableView.scrollToBottom()
    }

    /// キーボードが表示されたときの処理
    ///
    /// - Parameter notification: 通知情報
    func keyboardWillShow(notification: Notification) {

        let rect = (notification
            .userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue

        let duration = notification
            .userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double

        UIView.animate(withDuration: duration!,
                       animations: { [weak self] () in
            let transform = CGAffineTransform(translationX: 0,
                                              y: -(rect?.size.height)!)
            self?.view.transform = transform

        })
    }

    /// キーボードが非表示されたときの処理
    ///
    /// - Parameter notification: 通知情報
    func keyboardWillHide(notification: Notification) {

        let duration = notification
            .userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double

        UIView.animate(withDuration: duration!,
                       animations: { [weak self] () in

                        self?.view.transform = CGAffineTransform.identity
        })
    }

    /// 送信ボタンが押下されたあとに、キーボードを初期状態に戻す処理
    private func setupTextView() {

        inputTextView.text = ""
        let size = inputTextView.sizeThatFits(inputTextView.frame.size)
        constraintTextViewHeight.constant = size.height
        inputTextView.resignFirstResponder()
    }

    /// キーボードの表示/非表示をNotificationで受け取れるように登録する
    private func addKeyboardShowHideEvent() {

        let notification = NotificationCenter.default

        notification.addObserver(self,
                                 selector: .keyboardWillShow,
                                 name: Notification.Name.UIKeyboardWillShow,
                                 object: nil)

        notification.addObserver(self,
                                 selector: .keyboardWillHide,
                                 name: Notification.Name.UIKeyboardWillHide,
                                 object: nil)

        isObserving = true
    }

    /// addKeyboardShowHideEventで登録したイベントを解除する
    private func removeKeyboardShowHideEvent() {

        if !isObserving { return }

        let notification = NotificationCenter.default

        notification.removeObserver(self,
                                    name: Notification.Name.UIKeyboardWillShow,
                                    object: nil)

        notification.removeObserver(self,
                                    name: Notification.Name.UIKeyboardWillHide,
                                    object: nil)

        isObserving = false
    }
}

// MARK: - UITextViewDelegate
extension MessageListViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        /// 高さの上限
        let maxHeight = CGFloat(100.0)

        sendButton.isEnabled = textView.text.characters.count > 0

        if inputTextView.frame.size.height < maxHeight {

            let size = textView.sizeThatFits(inputTextView.frame.size)
            constraintTextViewHeight.constant = size.height
        }
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {

        inputTextView.scrollRangeToVisible(inputTextView.selectedRange)
        return true
    }
}
