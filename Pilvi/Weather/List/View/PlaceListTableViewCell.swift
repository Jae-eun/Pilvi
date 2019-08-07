//
//  PlaceListTableViewCell.swift
//  Pilvi
//
//  Created by 이재은 on 05/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class PlaceListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timeLabel.text = nil
        placeLabel.text = nil
        temperatureLabel.text = nil
    }
    
    // MARK: - Method
    
    func setProperties(placeData: WeatherModel, placeName: String) {
        timeLabel.text = "\(changeTime(placeData.currently.time))"
        placeLabel.text = "\(placeName)"
        temperatureLabel.text
            = "\(self.changeCelcius(fahrenheit: placeData.currently.temperature))°"
    }
    
    private func changeCelcius(fahrenheit: Double) -> Int {
        return Int((fahrenheit - 32) * (5/9))
    }
    
    private func changeTime(_ date: Int) -> String {
        let dateFormat = DateFormat(date: Date(timeIntervalSince1970: Double(date)))
        return dateFormat.time
    }
    
}
