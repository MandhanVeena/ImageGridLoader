//
//  PAThumbnail.swift
//  ImageGridLoader
//
//  Created by Veena on 06/05/24.
//

import Foundation

struct PAThumbnail: Decodable {
    let domain: String
    let basePath: String
    let key: String
    
    func imageURL() -> URL? {
        let urlString = "\(domain)/\(basePath)/0/\(key)"
        return URL(string: urlString)
    }
}
