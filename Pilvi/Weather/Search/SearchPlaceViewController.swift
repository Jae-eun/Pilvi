//
//  SearchPlaceViewController.swift
//  Pilvi
//
//  Created by 이재은 on 05/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class SearchPlaceViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    // MARK: - Property
    
    private var placeSearchController = UISearchController()
    private let reuseIdentifier: String = "ResultCell"
    private var placeResults: [MKLocalSearchCompletion]?
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
        return searchCompleter
    }()
    private var latitudeArray: [CLLocationDegrees]
        = UserDefaults.standard.array(forKey: "latitude") as? [CLLocationDegrees] ?? []
    private var longitudeArray: [CLLocationDegrees]
        = UserDefaults.standard.array(forKey: "longitude") as? [CLLocationDegrees] ?? []
    private var placeNameArray: [String]
        = UserDefaults.standard.array(forKey: "placeName") as? [String] ?? []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        setSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    // MARK: - Method
    
    private func addLocation(_ latitudeArray: [CLLocationDegrees],
                             _ longitudeArray: [CLLocationDegrees],
                             _ placeNameArray: [String]) {
        UserDefaults.standard.set(latitudeArray, forKey: "latitude")
        UserDefaults.standard.set(longitudeArray, forKey: "longitude")
        UserDefaults.standard.set(placeNameArray, forKey: "placeName")
        UserDefaults.standard.synchronize()
    }
    
    private func checkoutExistPlace(_ latitude: CLLocationDegrees,
                                    _ longitude: CLLocationDegrees,
        _ placeName: String) -> Bool {
        let isExist = true
        if let latitudeArray = UserDefaults.standard
            .array(forKey: "latitude") as? [CLLocationDegrees],
            !latitudeArray.contains(latitude),
            let longitudeArray = UserDefaults.standard
                .array(forKey: "longitude") as? [CLLocationDegrees],
            !longitudeArray.contains(longitude),
            let placeNameArray = UserDefaults.standard
                .array(forKey: "placeName") as? [String],
            !placeNameArray.contains(placeName){
            return !isExist
        } else {
            return isExist
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension SearchPlaceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: reuseIdentifier,
                                 for: indexPath)
            as? SearchResultTableViewCell
            else { return UITableViewCell() }
        
        if let placeResult = placeResults?[indexPath.row] {
            cell.setProperties(placeResult.title,
                               part: placeSearchController.searchBar.text ?? "")
        }
        
        return cell
    }
    
    private func moveListViewController() {
        let storyboard = UIStoryboard(name: "List",
                                      bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ListViewController")
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
    }
    
}

// MARK: - UITableViewDelegate

extension SearchPlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCell = tableView.cellForRow(at: indexPath)
            as? SearchResultTableViewCell else { return }
        
        let geocoder = CLGeocoder()
        guard let placeName = currentCell.resultLabel.text else { return }
        geocoder.geocodeAddressString(placeName) { [weak self] place, error in
            let place = place?.first
            guard let latitude = place?.location?.coordinate.latitude,
                let longitude = place?.location?.coordinate.longitude else { return }
            print("latitude: \(String(describing: latitude)), longitude: \(String(describing: longitude))")
            
            if self?.checkoutExistPlace(latitude, longitude, placeName) == false {
                self?.latitudeArray.append(latitude)
                self?.longitudeArray.append(longitude)
                self?.placeNameArray.append(placeName)
                self?.addLocation(self?.latitudeArray ?? [],
                                  self?.longitudeArray ?? [],
                                  self?.placeNameArray ?? [])
            }
            
            self?.moveListViewController()
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchPlaceViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchCompleter.queryFragment = searchText
    }
}

// MARK: - UISearchBarDelegate

extension SearchPlaceViewController: UISearchBarDelegate {
    
    private func setSearchController() {
        placeSearchController = UISearchController(searchResultsController: nil)
        placeSearchController.searchBar.delegate = self
        placeSearchController.searchResultsUpdater = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = placeSearchController
        placeSearchController.searchBar.becomeFirstResponder()
        placeSearchController.searchBar.barStyle = .blackTranslucent
        placeSearchController.searchBar.showsCancelButton = true
        placeSearchController.searchBar.showsSearchResultsButton = true
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension SearchPlaceViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        placeResults = completer.results
        DispatchQueue.main.async { [weak self] in
            self?.searchResultTableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        print(error.localizedDescription)
    }
    
}

