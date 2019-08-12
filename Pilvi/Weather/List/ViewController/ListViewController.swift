//
//  ListViewController.swift
//  Pilvi
//
//  Created by 이재은 on 05/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit
import CoreLocation

final class ListViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var placeListTableView: UITableView!
    
    // MARK: - Property
    
    private let reuseIdentifier: String = "ListCell"
    private var latitudeArray: [CLLocationDegrees]
        = UserDefaults.standard.array(forKey: "latitude") as? [CLLocationDegrees] ?? []
    private var longitudeArray: [CLLocationDegrees]
        = UserDefaults.standard.array(forKey: "longitude") as? [CLLocationDegrees] ?? []
    private var placesData: [WeatherModel] = []
    private var placeNameArray: [String]
        = UserDefaults.standard.array(forKey: "placeName") as? [String] ?? []
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    private let weatherListGroup = DispatchGroup()
    private let weatherListQueue = DispatchQueue(label: "weatherListQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRefreshControl()
        fetchWeatherData(count: placeNameArray.count)
    }
    
    // MARK: - Method
    
    private func fetchWeatherData(count: Int) {
        for index in 0..<count {
            weatherListQueue.async(group: weatherListGroup) { [weak self] in
                guard let self = self else { return }
                WeatherService.shared.fetchWeather(
                    latitude: self.latitudeArray[index],
                    longitude: self.longitudeArray[index],
                    success: { [weak self] result in
                        if self?.placesData.count != self?.placeNameArray.count {
                            self?.placesData.append(result)
                        }
                        DispatchQueue.main.async { [weak self] in
                            self?.placeListTableView.reloadData()
                        }
                    }, errorHandler: {
                        print("error")
                        return
                })
            }
            self.weatherListGroup.wait()
            
        }
    }
    
    private func moveMainViewController(_ indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            viewController.weatherData = placesData
            viewController.collectionViewIndexPath = indexPath
            self.navigationController?.pushViewController(viewController,
                                                          animated: true)
        }
    }
    
    private func setLocation(_ latitudeArray: [CLLocationDegrees],
                             _ longitudeArray: [CLLocationDegrees],
                             _ placeNameArray: [String]) {
        
        UserDefaults.standard.set(latitudeArray, forKey: "latitude")
        UserDefaults.standard.set(longitudeArray, forKey: "longitude")
        UserDefaults.standard.set(placeNameArray, forKey: "placeName")
        UserDefaults.standard.synchronize()
    }
    
    private func configureRefreshControl() {
        placeListTableView.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(handleRefreshControl),
                                 for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        fetchWeatherData(count: placeNameArray.count)
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return placesData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: reuseIdentifier,
                                 for: indexPath) as? PlaceListTableViewCell
            else { return UITableViewCell() }
        
        let placeData = placesData[indexPath.row]
        cell.setProperties(placeData: placeData,
                           placeName: placeNameArray[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isSelected = false
        moveMainViewController(indexPath)
    }
    
}
