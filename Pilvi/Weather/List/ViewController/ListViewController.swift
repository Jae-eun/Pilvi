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
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchWeatherData(count: latitudeArray.count)
    }
    
    // MARK: - Method
    
    private func fetchWeatherData(count: Int) {
        
        for index in 0..<count {
            WeatherService.shared.fetchWeather(
                latitude: latitudeArray[index],
                longitude: longitudeArray[index],
                date: Date(),
                success: { [weak self] result in
                    
                    self?.placesData.append(result)
                }, errorHandler: {
                    print("error")
            })
        }
        DispatchQueue.main.async { [weak self] in
            self?.placeListTableView.reloadData()
        }
    }
    
    private func moveMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
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
        fetchWeatherData(count: latitudeArray.count)
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.placeListTableView.reloadData()
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PlaceListTableViewCell
            else { return UITableViewCell() }
        
        let placeData = placesData[indexPath.row]
        cell.setProperties(placeData: placeData, placeName: placeNameArray[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            placesData.remove(at: indexPath.row)
            latitudeArray.remove(at: indexPath.row)
            longitudeArray.remove(at: indexPath.row)
            placeNameArray.remove(at: indexPath.row)
            setLocation(latitudeArray, longitudeArray, placeNameArray)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        guard let currentCell = tableView.cellForRow(at: indexPath)
        //            as? PlaceListTableViewCell else { return }
        
        moveMainViewController()
    }
    
}

