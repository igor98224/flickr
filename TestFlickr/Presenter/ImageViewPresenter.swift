//
//  ImageViewPresenter.swift
//  TestFlickr
//
//  Created by Ihar Moroz on 10.06.21.
//

import Foundation

class ImageViewPresenter {
    let network = Networking()
    var photos: [PhotoModel] = []
    
    public func getPhotos(page: Int = 1, searchText: String? = nil, completion: @escaping ([PhotoModel]) -> Void) {
        network.fetchPhotosFromAPI(searchText: searchText, page: String(page)) { [weak self] photos in
            guard let self = self else { return }
            if page == 1 {
                self.photos = photos ?? []
            } else if let photos = photos {
                self.photos.append(contentsOf: photos)
            }
            completion(photos ?? [])
        }
    }
}
