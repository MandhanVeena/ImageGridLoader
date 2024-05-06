//
//  AsyncImageView.swift
//  ImageGridLoader
//
//  Created by Veena on 07/05/24.
//

import Foundation
import UIKit

class AsyncImageView: UIImageView {
    
    var task: URLSessionDataTask!
    
    func loadImage(url: URL) {
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let newImage = UIImage(data: data) else {
                print("Couldn't load image from url: \(url)")
                return
            }
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
