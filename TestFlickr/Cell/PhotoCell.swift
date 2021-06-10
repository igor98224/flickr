//
//  PhotoCell.swift
//  TestFlickr
//
//  Created by Ihar Moroz on 8.06.21.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
    
    var imageURL: String? {
        didSet {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                photoImageView.kf.setImage(with: url, placeholder: UIImage(named: "empty"))
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageURL = nil
    }
    
    public func cancelImageLoading() {
        photoImageView.kf.cancelDownloadTask()
    }
}
