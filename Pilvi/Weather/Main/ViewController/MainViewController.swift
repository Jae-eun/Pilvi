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
    var weatherData: [WeatherModel] = []
    private var placeNameArray: [String]
        = UserDefaults.standard.array(forKey: "placeName") as? [String] ?? []
    var collectionViewIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
   
        UserDefaults.standard.set(placeNameArray, forKey: "placeName")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mainCollectionView.layoutIfNeeded()
        mainCollectionView.scrollToItem(at: collectionViewIndexPath,
                                        at: .right,
                                        animated: false)
        DispatchQueue.main.async { [weak self] in
            self?.mainCollectionView.reloadData()
        }
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
        cell.cityName = placeNameArray[indexPath.item]
        cell.hourCollectionView.reloadData()
        cell.dayTableView.reloadData()
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}
