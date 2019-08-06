//
//  Hourly.swift
//  Pilvi
//
//  Created by 이재은 on 04/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

struct Hourly: Codable {
    let summary: String
    let icon: String
    let data: [Currently]
}

