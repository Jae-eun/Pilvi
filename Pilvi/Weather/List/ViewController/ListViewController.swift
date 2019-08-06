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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchWeatherData(count: latitudeArray.count)
    }
    
    @IBAction func openSearchViewController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "List",
                                      bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchPlaceViewController")
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
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
        
        print(latitudeArray.count)
        print("ppppp\(placesData.count)")
        print(indexPath.row)
        let placeData = placesData[indexPath.row]
        print(placeData.timezone)
        cell.setProperties(placeData: placeData)
        return cell
    }
    
    
}

extension ListViewController: UITableViewDelegate {
    
}
