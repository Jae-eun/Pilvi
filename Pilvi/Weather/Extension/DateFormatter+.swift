//
//  DateFormatter+.swift
//  Pilvi
//
//  Created by 이재은 on 07/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

extension DateFormatter {

    static let defaultDate: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
}
