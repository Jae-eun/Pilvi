//
//  PlaceCollectionViewCell.swift
//  Pilvi
//
//  Created by 이재은 on 02/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class PlaceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var hourCollectionView: UICollectionView!
    @IBOutlet private weak var dayTableView: UITableView!
    @IBOutlet private weak var todayWeatherView: TodayWeatherView!
    @IBOutlet private weak var shortTextView: ShortTextView!
    @IBOutlet private weak var detailStackView: DetailStackView!
    
    // MARK: - Property
    
    private let reuseIdentifiers: [String] = ["HourCell", "DayCell"]
    var weatherData: WeatherModel? = nil
    var cityName: String?
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hourCollectionView.dataSource = self
        dayTableView.dataSource = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        todayWeatherView = nil
        shortTextView = nil
        detailStackView = nil
    }
    
    // MARK: - Method
    
    private func sendUIViewData(_ weatherData: WeatherModel) {
        todayWeatherView.currentlyData = weatherData.currently
        todayWeatherView.dailyData = weatherData.daily.data[0]
        todayWeatherView.cityName = cityName
        shortTextView.dailyData = weatherData.daily.data[0]
        detailStackView.currentlyData = weatherData.currently
        detailStackView.dailyData = weatherData.daily.data[0]
        
    }
}

// MARK: - UICollectionViewDataSource

extension PlaceCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if weatherData?.hourly.data.count ?? 0 < 26 {
            return weatherData?.hourly.data.count ?? 0
        } else {
            return 25
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifiers[0], for: indexPath) as? HourCollectionViewCell
            else { return UICollectionViewCell() }
        
        if let hourlyData = weatherData?.hourly.data[indexPath.item] {
            cell.setProperties(hourlyData)
        }
        
        return cell
    }
}

// MARK: - UITableViewDataSource

extension PlaceCollectionViewCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return weatherData?.daily.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: reuseIdentifiers[1],
                                 for: indexPath) as? DayWeatherTableViewCell
            else { return UITableViewCell() }
        
        if let dailyData = weatherData?.daily.data[indexPath.item] {
            cell.setProperties(dailyData)
        }
        if indexPath.item == 0 {
            if let weatherData = weatherData {
                sendUIViewData(weatherData)
            }
        }
        
        return cell
    }
    
}
