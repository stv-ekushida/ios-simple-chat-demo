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

    //MARK:- Properties
    private let dataSource = MessageListProvider()
    private var isObserving = false

    //MARK:- IBOutlet
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var constraintTextViewHeight: NSLayoutConstraint!
    
    //MARK:- IBAction
    @IBAction func didTapSendButton(_ sender: UIButton) {
        MessageDao.add(inputTextView.text)
        reloadMessages()
        setupTextView()
    }
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMessages()
        addKeyboardShowHideEvent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardShowHideEvent()
    }

    //MARK:- Private Methods
    private func setup() {
        messageTableView.estimatedRowHeight = 88
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.dataSource = dataSource
        messageTableView.contentInset.bottom = 44

        inputTextView.delegate = self
        sendButton.isEnabled = false
    }

    /// メッセージ一覧の表示
    private func reloadMessages() {

        let groups = MessageDao.groupByPostDate()

        let messages = groups.map {        
            MessageDao.findByPostDate($0)
        }

        dataSource.setMessageGroup(groups: groups)
        dataSource.setMessages(messages: messages)
        
        messageTableView.reloadData()
        scrollToNewMessage()
    }

    /// 最新のメッセージまで移動する
    private func scrollToNewMessage() {

        DispatchQueue.main.async { [weak self] _ in

            guard let section = self?.messageTableView.numberOfSections, section > 0 else {
                return
            }

            guard let row = self?.messageTableView
                .numberOfRows(inSection: section - 1) , row > 0 else {
                return
            }
            
            let indexPath = IndexPath(row: row - 1 , section: section - 1)

            self?.messageTableView.scrollToRow(at: indexPath,
                                              at: .bottom,
                                              animated: false)
        }
    }

    //MARK: - Keyboard

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
        sendButton.isEnabled = false
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
        let maxHeight: CGFloat = 100.0

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
