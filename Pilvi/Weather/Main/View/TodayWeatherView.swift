//
//  TodayWeatherView.swift
//  Pilvi
//
//  Created by 이재은 on 06/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class TodayWeatherView: UIView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var placeLabel: UILabel! 
    @IBOutlet private weak var summeryLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var higherTemperatureLabel: UILabel!
    @IBOutlet private weak var lowerTemperatureLabel: UILabel!
    
    // MARK: - Property
    
    var cityName: String? {
        didSet {
            if let cityName = cityName {
                setCityName(text: cityName)
            }
        }
    }
    var currentlyData: Currently? {
        didSet {
            if let currentlyData = currentlyData, let dailyData = dailyData {
                setTodayWeather(currentlyData, dailyData)
            }
        }
    }
    var dailyData: DailyData? {
        didSet {
            if let currentlyData = currentlyData, let dailyData = dailyData {
                setTodayWeather(currentlyData, dailyData)
            }
        }
    }
    
    // MARK: - Method
    
    private func setTodayWeather(_ currently: Currently, _ daily: DailyData) {
        let temperature = changeCelcius(fahrenheit: currently.temperature)
        let day = changeWeekDay(currently.time)
        let higherTemperature = changeCelcius(fahrenheit: daily.temperatureHigh)
        let lowerTemperature = changeCelcius(fahrenheit: daily.temperatureLow)
        
        DispatchQueue.main.async { [weak self] in
            self?.summeryLabel.text = "\(currently.summary)"
            self?.temperatureLabel.text = "\(temperature)°"
            self?.dayLabel.text = "\(day)"
            self?.higherTemperatureLabel.text = "\(higherTemperature)"
            self?.lowerTemperatureLabel.text = "\(lowerTemperature)"
        }
    }
    
    private func setCityName(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.placeLabel.text = "\(text)"
        }
    }
    
    private func changeCelcius(fahrenheit: Double) -> Int {
        return Int((fahrenheit - 32) * (5/9))
    }
    
    private func changeWeekDay(_ date: Int) -> String {
        let dateFormat = DateFormat(date: Date(timeIntervalSince1970: Double(date)))
        return dateFormat.weekDay
    }
}
