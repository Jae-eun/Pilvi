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
    
    private var latitudeArray: [CLLocationDegrees] = UserDefaults.standard.array(forKey: "latitude") as? [CLLocationDegrees] ?? []
    private var longitudeArray: [CLLocationDegrees] = UserDefaults.standard.array(forKey: "longitude") as? [CLLocationDegrees] ?? []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setSearchController()
    }
    
    // MARK: - Method
    
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
    
}

// MARK: - UITableViewDelegate

extension SearchPlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCell = tableView.cellForRow(at: indexPath)
            as? SearchResultTableViewCell else { return }
        
        let geocoder = CLGeocoder()
        guard let name = currentCell.resultLabel.text else { return }
        geocoder.geocodeAddressString(name) { [weak self] place, error in
            let place = place?.first
            guard let latitude = place?.location?.coordinate.latitude,
                let longitude = place?.location?.coordinate.longitude else { return }
            print("latitude: \(String(describing: latitude)), longitude: \(String(describing: longitude))")
            
            if self?.checkoutExistPlace(latitude, longitude) == false {
                self?.latitudeArray.append(latitude)
                self?.longitudeArray.append(longitude)
                self?.addLocation(self?.latitudeArray ?? [], self?.longitudeArray ?? [])
            }
            
            self?.navigationController?.popViewController(animated: true)
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
