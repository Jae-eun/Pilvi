//
//  DayWeatherTableViewCell.swift
//  Pilvi
//
//  Created by 이재은 on 02/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class DayWeatherTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var higherTemperatureLabel: UILabel!
    @IBOutlet private weak var lowerTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Method
    
    func setProperties(_ data: DailyData) {
        dayLabel.text = "\(changeWeekDay(data.time))"
        iconImageView.image = UIImage(named: "\(data.icon)")
        higherTemperatureLabel.text = "\(changeCelcius(fahrenheit: data.temperatureHigh))"
        lowerTemperatureLabel.text = "\(changeCelcius(fahrenheit: data.temperatureLow))"
    }
    
    private func changeCelcius(fahrenheit: Double) -> Int {
        return Int((fahrenheit - 32) * (5/9))
    }

    private func changeWeekDay(_ date: Int) -> String {
        let dateFormat = DateFormat(date: Date(timeIntervalSince1970: Double(date)))
        return dateFormat.weekDay
    }

}
