//
//  PhotoViewController.swift
//  TestFlickr
//
//  Created by Ihar Moroz on 8.06.21.
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController {
    public var photo: PhotoModel?
    @IBOutlet private weak var imageView: UIImageView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        if let photo = photo, let url = URL(string: photo.imageURL) {
            imageView.kf.setImage(with: url)
        }
    }
    
    private func setupGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
    }
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
}
