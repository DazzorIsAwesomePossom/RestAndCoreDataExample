//
//  COGeoNames.swift
//  CodeOasisAssigment
//
//  Created by Dan Fechtmann on 18/10/2018.
//  Copyright © 2018 Dan Fechtmann. All rights reserved.
//

import Foundation


final class COGeoNames: Codable {
    var geonames: [COGeoName]?
    
    init() {
        geonames = []
    }
}
