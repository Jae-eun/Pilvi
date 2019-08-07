//
//  MainViewController.swift
//  Pilvi
//
//  Created by 이재은 on 05/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    
    // MARK: - Property
    
    private let reuseIdentifier: String = "PlaceCell"
    private var weatherData: [WeatherModel] = []
    private var currentlyData: [Currently] = []
    private var dailyData: [DailyData] = []
    private var latitudeArray: [CLLocationDegrees]
        = UserDefaults.standard.array(forKey: "latitude") as? [CLLocationDegrees] ?? []
    private var longitudeArray: [CLLocationDegrees]
        = UserDefaults.standard.array(forKey: "longitude") as? [CLLocationDegrees] ?? []
    private var locationManager: CLLocationManager!
    private var placeNameArray: [String]
        = UserDefaults.standard.array(forKey: "placeName") as? [String] ?? []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.dataSource = self
        
        UserDefaults.standard.set(latitudeArray, forKey: "latitude")
        UserDefaults.standard.set(longitudeArray, forKey: "longitude")
        
        fetchWeather(count: latitudeArray.count)
        
    }
    
    // MARK: - Methods
    
    private func fetchWeather(count: Int) {
        for index in 0..<count {
            WeatherService.shared.fetchWeather(
                latitude: latitudeArray[index],
                longitude: longitudeArray[index],
                date: Date(),
                success: { [weak self] result in
                    self?.weatherData.append(result)
                    self?.currentlyData.append(result.currently)
                    self?.dailyData.append(result.daily.data[0])
                    print(self?.weatherData)
                    print(self?.dailyData)
                    
                }, errorHandler: {
                    print("error")
            })
        }
        DispatchQueue.main.async { [weak self] in
            self?.mainCollectionView.reloadData()
        }
    }
    
    private func addLocation(_ latitudeArray: [CLLocationDegrees],
                             _ longitudeArray: [CLLocationDegrees],
                             _ placeNameArray: [String]) {
        UserDefaults.standard.set(latitudeArray, forKey: "latitude")
        UserDefaults.standard.set(longitudeArray, forKey: "longitude")
        UserDefaults.standard.set(placeNameArray, forKey: "placeName")
        UserDefaults.standard.synchronize()
    }
    
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return weatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                 for: indexPath) as? PlaceCollectionViewCell
            else { return UICollectionViewCell() }
        
        cell.weatherData = weatherData[indexPath.item]
        print(placeNameArray)
        cell.cityName = placeNameArray[indexPath.item]
        
        return cell
    }
}
