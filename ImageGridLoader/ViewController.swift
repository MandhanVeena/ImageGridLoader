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
        
        thumbnailViewModel.fetchImageData() { [weak self] success in
            switch(success) {
            case true:
                self?.reload()
            case false:
                break
            }
        }
        
    }
    
    func setupCollectionView(){
        collectionView.register(PACollectionViewCell.nib(), forCellWithReuseIdentifier: PACollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reload(){
        // Reload the collection view on the main thread
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    //ToDo: Remove if not needed
}

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
    //ToDo: Constant for cell spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width - 20)/3, height: (view.frame.size.width - 20)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
