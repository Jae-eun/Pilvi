//
//  ShortTextView.swift
//  Pilvi
//
//  Created by 이재은 on 06/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class ShortTextView: UIView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var shortTextLabel: UILabel!
    
    // MARK: - Property
    
    var dailyData: DailyData? {
        didSet {
            if let dailyData = dailyData {
                setShortText(dailyData)
            }
        }
    }
    
    // MARK: - Method
    
    private func setShortText(_ data: DailyData) {
        let highterTemperature = changeCelcius(fahrenheit: data.temperatureHigh)
        let lowerTemperature = changeCelcius(fahrenheit: data.temperatureLow)
        
        DispatchQueue.main.async { [weak self] in
            self?.shortTextLabel.text
                = "* 오늘: 현재 날씨 \(data.summary). \n* 최고 기온은 \(  highterTemperature)°입니다. \n* 오늘 밤 날씨 \(data.summary), 최저 기온은 \(lowerTemperature)°입니다."
        }
    }
    
    private func changeCelcius(fahrenheit: Double) -> Int {
        return Int((fahrenheit - 32) * (5/9))
    }
    
}
