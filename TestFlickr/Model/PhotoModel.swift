//
//  PhotoModel.swift
//  TestFlickr
//
//  Created by Ihar Moroz on 8.06.21.
//

import Foundation
import SwiftyJSON

struct PhotoModel {
    var imageURL: String
    
    init?(json: JSON) {
        guard let urlZ = json["url_z"].string else { return nil }
        self.imageURL = urlZ
    }
}
