//
//  PAThumbnailViewModel.swift
//  ImageGridLoader
//
//  Created by Veena on 07/05/24.
//

import Foundation
import UIKit

class PAThumbnailViewModel {
    var imageUrls = [String]()
    
    func fetchImageData(completion: @escaping (Bool) -> Void) {
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to fetch data: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                self.extractImageUrls(from: jsonArray)
                completion(true)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func extractImageUrls(from jsonArray: [[String: Any]]?) {
        guard let jsonArray = jsonArray else { return }
        
        for dict in jsonArray {
            if let thumbnail = dict["thumbnail"] as? [String: Any],
               let domain = thumbnail["domain"] as? String,
               let basePath = thumbnail["basePath"] as? String,
               let key = thumbnail["key"] as? String {
                let imageUrl = "\(domain)/\(basePath)/0/\(key)"
                
                self.imageUrls.append(imageUrl)
            }
        }
    }
}
