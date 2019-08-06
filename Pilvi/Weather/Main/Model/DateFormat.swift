//
//  DateFormat.swift
//  Pilvi
//
//  Created by 이재은 on 07/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

struct DateFormat {
    let weekDay: String
    let day: String
    let full: String
    let hour: String
    let time: String
    
    init(date input: Date?) {
        let date: Date = input ?? Date()
        
        let dateFormatter = DateFormatter.defaultDate
        dateFormatter.locale = Locale.init(identifier: "ko")
        
        dateFormatter.dateFormat = "EEEE"
        weekDay = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "d"
        day = dateFormatter.string(from: date)
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        full = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "a HH"
        hour = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "a HH:mm"
        time = dateFormatter.string(from: date)
   
    }
}
