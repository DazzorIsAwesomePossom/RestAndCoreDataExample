//
//  GeoName.swift
//  CodeOasisAssigment
//
//  Created by Dan Fechtmann on 18/10/2018.
//  Copyright © 2018 Dan Fechtmann. All rights reserved.
//

import Foundation


final class COGeoName: Codable {
    
    var summary: String?
    var elevation: Int?
    var geoNameId: Int?
    var feature: String?
    var lng: Float?
    var countryCode: String?
    var rank: Int?
    var thumbnailImg: String?
    var lang: String?
    var title: String?
    var lat: Float?
    var wikipediaUrl: String?
    
}
