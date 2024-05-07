//
//  AsyncImageView.swift
//  ImageGridLoader
//
//  Created by Veena on 07/05/24.
//

import UIKit

class AsyncImageView: UIImageView {
    
    private let imageMemoryCache = NSCache<NSString, UIImage>()
    
    private let imageDiskCacheDirectory: URL = {
        // Directory path for storing cached images
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access cache directory")
        }
        // Append directory name
        let directoryURL = cacheDirectory.appendingPathComponent("PAImageCache")
        
        // Creating cache directory if it doesn't exist
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            fatalError("Error creating cache directory: \(error.localizedDescription)")
        }
        return directoryURL
    }()
    
    private var task: URLSessionDataTask?
    var placeholderImage: UIImage? = UIImage(systemName: "photo.fill")?
        .withTintColor(.lightGray)
        .withRenderingMode(.alwaysOriginal)
        .withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .ultraLight, scale: .small))
    
    func loadImage(from url: URL) {
        image = placeholderImage
        
        // Cancel ongoing task if any
        task?.cancel()
        // Check memory cache
        if let cachedImage = imageMemoryCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            print("Image loaded from memory cache")
            return
        }
        
        // Check disk cache
        if let cachedImage = loadImageFromDiskCache(with: url) {
            // Update memory cache
            imageMemoryCache.setObject(cachedImage, forKey: url.absoluteString as NSString)
            self.image = cachedImage
            print("Image loaded from disk cache")
            return
        }
        
        // Fetch image from URL
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let newImage = UIImage(data: data) else {
                print("Error loading image from url: \(url), error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            print("Image loaded from API")
            
            // Update memory cache
            self.imageMemoryCache.setObject(newImage, forKey: url.absoluteString as NSString)
            
            // Save image to disk cache
            self.saveImageToDiskCache(newImage, with: url)
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task?.resume()
    }
    
    private func loadImageFromDiskCache(with url: URL) -> UIImage? {
        let imagePath = imageDiskCacheDirectory.appendingPathComponent(url.pathComponents[2])
        guard let imageData = try? Data(contentsOf: imagePath), let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
    
    private func saveImageToDiskCache(_ image: UIImage, with url: URL) {
        let imagePath = imageDiskCacheDirectory.appendingPathComponent(url.pathComponents[2])
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        do {
            try imageData.write(to: imagePath)
        } catch {
            print("Error saving image to disk: \(error.localizedDescription)")
        }
    }
}
