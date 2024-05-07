//
//  AsyncImageView.swift
//  ImageGridLoader
//
//  Created by Veena on 07/05/24.
//

import UIKit

class AsyncImageView: UIImageView {
    
    private let imageCache = NSCache<NSString, UIImage>()
    private var task: URLSessionDataTask?
    
    var placeholderImage: UIImage? = UIImage(systemName: "photo.fill")?
        .withTintColor(.lightGray)
        .withRenderingMode(.alwaysOriginal)
        .withConfiguration(UIImage.SymbolConfiguration(scale: .small))
    
    func loadImage(from url: URL) {
        image = placeholderImage
        
        // Cancel ongoing task if any
        task?.cancel()
        
        // Check cache
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            print("Image loaded from cache")
            return
        }
        
        // Fetch image from URL
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let newImage = UIImage(data: data) else {
                print("Error loading image from url: \(url), error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            print("From API")
            // Cache the image
            self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task?.resume()
    }
}
