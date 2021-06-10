//
//  APIModel.swift
//  TestFlickr
//
//  Created by Ihar Moroz on 9.06.21.
//

import Foundation

struct APIModel: Encodable {
    var method: String
    var api_key: String
    var per_page: String
    var page: String
    var format: String
    var nojsoncallback: String
    var extras: String
    var text: String?
    
    init(method: String, api_key: String, per_page: String, page: String, format: String, nojsoncallback: String, extras: String) {
        self.method = method
        self.api_key = api_key
        self.per_page = per_page
        self.page = page
        self.format = format
        self.nojsoncallback = nojsoncallback
        self.extras = extras
    }
}
