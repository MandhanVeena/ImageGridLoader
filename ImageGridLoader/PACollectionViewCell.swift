//
//  PACollectionViewCell.swift
//  ImageGridLoader
//
//  Created by Veena on 07/05/24.
//

import UIKit

class PACollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: AsyncImageView!
    
    static let identifier = "PACollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupImageView()
    }
    
    private func setupImageView() {
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
    }

    public func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.loadImage(url: url)
        }
    }
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
}
