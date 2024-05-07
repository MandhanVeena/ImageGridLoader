//
//  AsyncImageView.swift
//  ImageGridLoader
//
//  Created by Veena on 07/05/24.
//

import UIKit

class AsyncImageView: UIImageView {
    /// Data task to fetch the image from specified URL asynchronously.
    private var task: URLSessionDataTask?
    
    private let imageMemoryCache = NSCache<NSString, UIImage>()
    
    private let imageDiskCacheDirectory: URL = {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access cache directory")
        }
        let directoryURL = cacheDirectory.appendingPathComponent("PAImageCache")
        
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            fatalError("Error creating cache directory: \(error.localizedDescription)")
        }
        return directoryURL
    }()
    
    var placeholderImage: UIImage? = UIImage(systemName: "photo.fill")?
        .withTintColor(.lightGray)
        .withRenderingMode(.alwaysOriginal)
        .withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .ultraLight, scale: .small))
    
    
    /// Function to load image asynchronously from memory cache, if not found, tries disk cache, else fetches from server
    /// - Parameter url: The URL of the image to be loaded.
    func loadImage(from url: URL) {
        task?.cancel()    // Cancel previous ongoing task if any
        
        image = placeholderImage
        
        // Check memory cache
        if let cachedImage = loadFromMemoryCache(with: url) {
            displayImage(cachedImage)
            print("Image loaded from memory cache")
            return
        }
        
        // Check disk cache
        if let cachedImage = loadFromDiskCache(with: url) {
            displayImage(cachedImage)
            saveToMemoryCache(cachedImage, for: url)
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
            
            displayImage(newImage)
            
            // Update memory cache
            self.saveToMemoryCache(newImage, for: url)
            
            // Save image to disk cache
            self.saveToDiskCache(newImage, with: url)
        }
        task?.resume()
    }
    
    private func displayImage(_ cachedImage: UIImage) {
        DispatchQueue.main.async {
            self.image = cachedImage
        }
    }

    private func loadFromMemoryCache(with url: URL) -> UIImage? {
        return imageMemoryCache.object(forKey: url.absoluteString as NSString)
    }

    private func saveToMemoryCache(_ image: UIImage, for url: URL) {
        imageMemoryCache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    private func loadFromDiskCache(with url: URL) -> UIImage? {
        let imagePath = imageDiskCacheDirectory.appendingPathComponent(url.pathComponents[2])
        guard let imageData = try? Data(contentsOf: imagePath), let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
    
    private func saveToDiskCache(_ image: UIImage, with url: URL) {
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
