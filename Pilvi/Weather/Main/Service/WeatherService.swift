//
//  WeatherService.swift
//  Pilvi
//
//  Created by 이재은 on 03/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

class WeatherService {
    
    // MARK: - Properties
    
    static let shared = WeatherService()
    private let baseURL = "https://api.darksky.net/forecast"
    private let APIKey = "efd8ed776c73ae4311259067ec5c09dd"
    
    // MARK: - Methods
    
    func fetchWeather (
        latitude: Double,
        longitude: Double,
        date: Date,
        success: @escaping (WeatherModel) -> Void,
        errorHandler: @escaping () -> Void) {
        let urlString  = "\(baseURL)/\(APIKey)/\(latitude),\(longitude)"
        guard let url: URL = URL(string: urlString) else { return }
        NetworkManager.request(url: url, success: success, errorHandler: errorHandler)
    }
    
}

