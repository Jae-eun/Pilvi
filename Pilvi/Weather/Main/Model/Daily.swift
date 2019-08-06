//
//  Daily.swift
//  Pilvi
//
//  Created by 이재은 on 04/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

struct Daily: Codable {
    let data: [DailyData]
}

struct DailyData: Codable {
    let time: Int
    let summary: String
    let icon: String
    let sunriseTime, sunsetTime: Int
    let precipIntensity: Double
    let precipProbability: Double
    let precipType: String
    let temperatureHigh: Double
    let temperatureLow: Double
    let apparentTemperatureHigh: Double
    let humidity, pressure, windSpeed: Double
}
