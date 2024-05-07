//
//  AsyncImageView.swift
//  ImageGridLoader
//
//  Created by Veena on 07/05/24.
//

import Foundation
import UIKit

class AsyncImageView: UIImageView {
    
    let imageCache = NSCache<NSString, UIImage>()
    
    var task: URLSessionDataTask!
    var placeholderImage: UIImage!
    
    func loadImage(url: URL) {

        if placeholderImage == nil {
            placeholderImage = createPlaceHolder()
        }
        
        image = placeholderImage
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = imageFromCache
            print("From cache")
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let newImage = UIImage(data: data) else {
                print("Couldn't load image from url: \(url)")
                return
            }
            
            print("From API")
            self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
    
    func createPlaceHolder() -> UIImage{
        let img = UIImage(systemName: "photo.fill")!
        
        // Change color to system red and apply small size configuration
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .ultraLight, scale: .small)
        
        let smallRedImage = img.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(smallConfig)
        
        return smallRedImage
    }
}
