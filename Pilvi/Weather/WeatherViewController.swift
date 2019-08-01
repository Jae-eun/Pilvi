//
//  WeatherViewController.swift
//  Pilvi
//
//  Created by 이재은 on 01/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {

    @IBOutlet private weak var weatherCollectionView: UICollectionView!
    
    private let reuseIdentifier = "PlaceCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlaceCollectionViewCell
            else { return UICollectionViewCell() }
        
        return cell
    }
    
//    guard let cell = collectionView
//        .dequeueReusableCell(withReuseIdentifier: "recommendCell",
//                             for: indexPath) as? RecommendCollectionViewCell
//    else { return UICollectionViewCell() }
//
//    let feedback = recommendFeedbacks[indexPath.item]
//    cell.setCollectionViewCellProperties(dustFeedback: feedback)
//    return cell
}

extension WeatherViewController: UICollectionViewDelegate {
    
}

