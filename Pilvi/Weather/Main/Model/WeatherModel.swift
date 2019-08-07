//
//  WeatherModel.swift
//  Pilvi
//
//  Created by 이재은 on 03/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    let latitude, longitude: Double
    let timezone: String
    let currently: Currently
    let hourly: Hourly
    let daily: Daily
}
