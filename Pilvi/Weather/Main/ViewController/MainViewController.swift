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
    @IBOutlet private weak var pageControlButton: UIBarButtonItem!
    
    
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
    private var currentLatitude: CLLocationDegrees?
    private var currentLongitude: CLLocationDegrees?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocationManager()
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        setCurrentWeather(currentLatitude ?? 42.3601, currentLongitude ?? -71.0589)
        
        UserDefaults.standard.set(latitudeArray, forKey: "latitude")
        UserDefaults.standard.set(longitudeArray, forKey: "longitude")
        
        updateWeather(count: 1)
    }
    
    // MARK: - IBAction
    
    @IBAction func channelButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func listButtonDidTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "List",
                                      bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ListViewController")
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
    }
    
    // MARK: - Methods
    
    private func updateWeather(count: Int) {
        for index in 0..<count {
            WeatherService.shared.fetchWeather(
                latitude: latitudeArray[index], //42.3601,//37.8267,
                longitude: longitudeArray[index], //-71.0589,//-122.4233,
                date: Date(),
                success: { [weak self] result in
                    self?.weatherData.append(result)
                    self?.currentlyData.append(result.currently)
                    self?.dailyData.append(result.daily.data[index])
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
    
    private func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func addLocation(_ latitudeArray: [CLLocationDegrees],
                             _ longitudeArray: [CLLocationDegrees]) {
        UserDefaults.standard.set(latitudeArray, forKey: "latitude")
        UserDefaults.standard.set(longitudeArray, forKey: "longitude")
        UserDefaults.standard.synchronize()
    }
    
    private func checkoutExistPlace(_ latitude: CLLocationDegrees,
                                    _ longitude: CLLocationDegrees) -> Bool {
        let isExist = true
        if let latitudeArray = UserDefaults.standard
            .array(forKey: "latitude") as? [CLLocationDegrees],
            !latitudeArray.contains(latitude),
            let longitudeArray = UserDefaults.standard
                .array(forKey: "longitude") as? [CLLocationDegrees],
            !longitudeArray.contains(longitude) {
            return !isExist
        } else {
            return isExist
        }
        
    }
    
    private func setCurrentWeather(_ latitude: CLLocationDegrees,
                                   _ longitude: CLLocationDegrees) {
        if checkoutExistPlace(latitude, longitude) == false {
            latitudeArray.append(latitude)
            longitudeArray.append(longitude)
            addLocation(latitudeArray, longitudeArray)
        }
    }
    
}
//if let currentlyData = self?.currentlyData,
//    let dailyData = self?.dailyData {
//    self?.sendDataToView(currentlyData[index], dailyData[index])
//    print(currentlyData)
//    print(dailyData)
//}

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
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

// MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = manager.location?.coordinate {
            
            currentLatitude = coordinate.latitude.rounded()
            currentLongitude = coordinate.longitude.rounded()
            print("latitude \(String(describing: currentLatitude)) longitude \(String(describing: currentLongitude))")
        }
        
    }
}

