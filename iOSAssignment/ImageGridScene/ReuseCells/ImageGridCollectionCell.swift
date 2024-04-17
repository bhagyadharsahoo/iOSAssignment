//
//  ImageGridCollectionCell.swift
//  iOSAssignment
//
//  Created by Bhagyadhar Sahoo on 14/04/24.
//

import UIKit

class ImageGridCollectionCell: UICollectionViewCell {
    
    static let nib = UINib(nibName: "ImageGridCollectionCell", bundle: nil)
    static let identifier = String(describing: ImageGridCollectionCell.self)
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(cell data: ImageData) {
        guard let imageUrl = URL(string: data.imageUrl ?? "") else { return }
        LazyImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
            guard let self, image != nil else {
                self?.loadImageInMainQueue(UIImage(named: "Placeholder"))
                return
            }
            loadImageInMainQueue(image)
        }
    }
    
    private func loadImageInMainQueue(_ image: UIImage?) {
        DispatchQueue.main.async { [weak self] in guard let self else { return }
            imageView.image = image
        }
    }
}




