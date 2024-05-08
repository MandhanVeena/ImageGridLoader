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
    
    private let imageDiskCacheDirectory: URL? = {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("Unable to access cache directory")
            return nil
        }
        let directoryURL = cacheDirectory.appendingPathComponent("PAImageCache")
        
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            return directoryURL
        } catch {
            print("Error creating cache directory: \(error.localizedDescription)")
            return nil
        }
    }()
    
    var placeholderImage: UIImage? = UIImage(systemName: "photo.circle")?
        .withTintColor(.lightGray)
        .withRenderingMode(.alwaysOriginal)
        .withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .ultraLight, scale: .small))
    
    
    // MARK: - Public Method
    
    /// Function to load image asynchronously from memory cache, if not found, tries disk cache, else fetches from server
    /// - Parameter url: The URL of the image to be loaded.
    func loadImage(from url: URL) {
        image = placeholderImage
        
        task?.cancel()    // Cancel previous ongoing task if any
        
        // Check memory cache
        if let cachedImage = loadFromMemoryCache(with: url) {
            displayImage(cachedImage)
            print("Image loaded from ---- Memory cache")
            return
        }
        
        // Check disk cache
        if let cachedImage = loadFromDiskCache(with: url) {
            displayImage(cachedImage)
            saveToMemoryCache(cachedImage, for: url)
            print("Image loaded from ---- Disk cache")
            return
        }
        
        // Fetch image from URL
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data,
                    let newImage = UIImage(data: data) else {
                print("Error loading image from url: \(url), error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            print("Image loaded from ---- URL")
            
            displayImage(newImage)
            
            self.saveToMemoryCache(newImage, for: url)
            
            self.saveToDiskCache(newImage, with: url)
        }
        task?.resume()
    }
    
    
    // MARK: - Private Methods
    
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
        guard let imagePath = imageDiskCacheDirectory?.appendingPathComponent(url.pathComponents[2]), 
                let imageData = try? Data(contentsOf: imagePath), 
                let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
    
    private func saveToDiskCache(_ image: UIImage, with url: URL) {
        guard let imagePath = imageDiskCacheDirectory?.appendingPathComponent(url.pathComponents[2]),
                let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        do {
            try imageData.write(to: imagePath)
        } catch {
            print("Error saving image to disk: \(error.localizedDescription)")
        }
    }
}
