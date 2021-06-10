//
//  Networking.swift
//  TestFlickr
//
//  Created by Ihar Moroz on 8.06.21.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking {
    func fetchPhotos(searchText: String? = nil, page: String, completion: (([PhotoModel]?) -> Void)? = nil) {
        let api = APIConfig()
        let url = URL(string: api.url)!
        var parameters = APIModel.init(method: "flickr.interestingness.getList", api_key: api.apiKey, per_page: "10", page: page, format: "json", nojsoncallback: "1", extras: "url_z")
        
        if let searchText = searchText, !searchText.isEmpty {
            parameters.method = "flickr.photos.search"
            parameters.text = searchText
        }
        
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success:
                    guard let data = response.data, let json = try? JSON(data: data) else {
                        print("Error")
                        completion?(nil)
                        return
                    }

                    let photosJSON = json["photos"]["photo"]
                    let photos = photosJSON.arrayValue.compactMap { PhotoModel(json: $0) }
                    completion?(photos)
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion?(nil)
                }
        }
    }
}
