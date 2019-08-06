//
//  Currently.swift
//  Pilvi
//
//  Created by 이재은 on 04/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

struct Currently: Codable {
    let time: Int
    let summary: String
    let icon: String
    let precipIntensity, precipProbability, temperature, apparentTemperature: Double
    let humidity, pressure, windSpeed: Double
}
