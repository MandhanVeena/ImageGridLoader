//
//  ViewController.swift
//  ImageGridLoader
//
//  Created by Veena on 05/05/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    let thumbnailViewModel = PAThumbnailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        // Fetch image data
        thumbnailViewModel.fetchThumbnailData() { [weak self] success in
            switch(success) {
            case true:
                self?.reload()
            case false:
                break
            }
        }
    }
    
    // MARK: - Collection View Setup
    
    private func setupCollectionView(){
        collectionView.register(PACollectionViewCell.nib(), forCellWithReuseIdentifier: PACollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    /// Reload the collection view on the main thread
    private func reload(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


// MARK: - ViewController Extensions for CollectionView

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailViewModel.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PACollectionViewCell.identifier, for: indexPath) as! PACollectionViewCell
        cell.configure(with: thumbnailViewModel.imageUrls[indexPath.item])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (view.frame.size.width - gridSpacing * 4) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return gridSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return gridSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: gridSpacing, left: gridSpacing, bottom: gridSpacing, right: gridSpacing)
    }
}
