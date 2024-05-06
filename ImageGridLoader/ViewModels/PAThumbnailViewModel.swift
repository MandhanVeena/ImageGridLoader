//
//  PAThumbnailViewModel.swift
//  ImageGridLoader
//
//  Created by Veena on 07/05/24.
//

import Foundation
import UIKit

class PAThumbnailViewModel {
    var images = [UIImage?]()
    
    func fetchImageData(completion: @escaping (Bool) -> Void) {
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            do {
                // Parse JSON response
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                
                // Extract image URLs from the JSON response and load images
                self?.loadImages(from: jsonArray, completion: completion)
                
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func loadImages(from jsonArray: [[String: Any]]?, completion: @escaping (Bool) -> Void) {
        guard let jsonArray = jsonArray else { return }
        
        for dict in jsonArray {
            if let thumbnail = dict["thumbnail"] as? [String: Any],
               let domain = thumbnail["domain"] as? String,
               let basePath = thumbnail["basePath"] as? String,
               let key = thumbnail["key"] as? String {
                let imageUrl = "\(domain)/\(basePath)/0/\(key)"
                
                // Load images asynchronously
                self.loadImage(from: imageUrl, completion: completion)
            }
        }
    }
    
    func loadImage(from urlString: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Failed to load image from URL: \(urlString)")
                return
            }
            // ToDo: Check Signal signout error if any
            // Update the images array with the loaded image
            self?.images.append(image)
            
            completion(true)
        }.resume()
    }
    
}
