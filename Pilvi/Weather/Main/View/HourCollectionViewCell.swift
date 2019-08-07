//
//  HourCollectionViewCell.swift
//  Pilvi
//
//  Created by 이재은 on 05/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class HourCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        hourLabel.text = nil
        iconImageView.image = nil
        temperatureLabel.text = nil
    }
    
    // MARK: - Method
    
    func setProperties(_ data: Currently) {
        hourLabel.text = "\(changeHour(data.time))시"
        iconImageView.image = UIImage(named: "\(data.icon)")
        temperatureLabel.text = "\(changeCelcius(fahrenheit: data.temperature))°"
    }
    
    private func changeCelcius(fahrenheit: Double) -> Int {
        return Int((fahrenheit - 32) * (5/9))
    }
    
    private func changeHour(_ date: Int) -> String {
        let dateFormat = DateFormat(date: Date(timeIntervalSince1970: Double(date)))
        return dateFormat.hour
    }
}
