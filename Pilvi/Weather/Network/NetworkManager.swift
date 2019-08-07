//
//  NetworkManager.swift
//  Pilvi
//
//  Created by 이재은 on 02/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation
import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    static func request<T: Decodable>(
        url: URL,
        success: @escaping (T) -> Void,
        errorHandler: @escaping () -> Void) {
        let session: URLSession = URLSession(configuration: .default)
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard let data = data else { return }
            
            if let error = error {
                errorHandler()
                print(error.localizedDescription)
                return
            }

            do {
                let apiResponse: T = try JSONDecoder().decode(T.self, from: data)
                success(apiResponse)
            } catch {
                errorHandler()
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
}
