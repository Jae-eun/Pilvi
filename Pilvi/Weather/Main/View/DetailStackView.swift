//
//  DetailStackView.swift
//  Pilvi
//
//  Created by 이재은 on 06/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class DetailStackView: UIStackView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var sunriseTimeLabel: UILabel!
    @IBOutlet private weak var sunsetTimeLabel: UILabel!
    @IBOutlet private weak var rainProbabilityLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var apparentTemperatureLabel: UILabel!
    @IBOutlet private weak var rainIndensityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    
    // MARK: - Property
    
    var currentlyData: Currently? {
        didSet {
            if let currentlyData = currentlyData, let dailyData = dailyData {
                setDetailProperties(currentlyData, dailyData)
            }
        }
    }
    var dailyData: DailyData? {
        didSet {
            if let currentlyData = currentlyData, let dailyData = dailyData {
                setDetailProperties(currentlyData, dailyData)
            }
        }
    }
    
    // MARK: - Method
    
    func setDetailProperties(_ currently: Currently, _ daily: DailyData) {
        
        let sunriseTime = changeTime(daily.sunriseTime)
        let sunsetTime = changeTime(daily.sunsetTime)
        let apparentTemperature = changeCelcius(fahrenheit: currently.apparentTemperature)
        
        DispatchQueue.main.async { [weak self] in
            self?.sunriseTimeLabel.text = "\(String(describing: sunriseTime))"
            self?.sunsetTimeLabel.text = "\(String(describing: sunsetTime))"
            self?.rainProbabilityLabel.text = "\(Int(currently.precipProbability * 100))%"
            self?.humidityLabel.text = "\(Int(currently.humidity * 100))%"
            self?.windLabel.text = "\(currently.windSpeed)m/s"
            self?.apparentTemperatureLabel.text = "\(String(describing: apparentTemperature))°"
            self?.rainIndensityLabel.text = "\(floor((currently.precipIntensity) / 100))cm"
            self?.pressureLabel.text = "\(Int(currently.pressure))hPa"
        }
    }
    
    private func changeCelcius(fahrenheit: Double) -> Int {
        return Int((fahrenheit - 32) * (5/9))
    }
    
    private func changeTime(_ date: Int) -> String {
        let dateFormat = DateFormat(date: Date(timeIntervalSince1970: Double(date)))
        return dateFormat.time
    }
}
