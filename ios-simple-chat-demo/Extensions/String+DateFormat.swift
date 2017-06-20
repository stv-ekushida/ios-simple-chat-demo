//
//  String+DateFormat.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/06/20.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import Foundation

extension String {

    func toDateStyleMedium(dateFormat: String) -> Date  {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = dateFormat

        return dateFormatter.date(from: self)!
    }
}
