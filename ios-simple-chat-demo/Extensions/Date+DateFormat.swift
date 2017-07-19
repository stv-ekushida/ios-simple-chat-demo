//
//  Date+DateFormat.swift
//  ios-simple-chat-demo
//
//  Created by Eiji Kushida on 2017/07/09.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import Foundation

extension Date {
    
    func dateStyleHHMM() -> String {
        
        let calendar = Calendar.current
        let components = calendar
            .dateComponents([.year, .month, .day, .hour, .minute],
                            from: self)
        
        if let hour = components.hour,
            let minite = components.minute {
            return String(format: "%02d:%02d",hour, minite)
        }
        return ""
    }
}
