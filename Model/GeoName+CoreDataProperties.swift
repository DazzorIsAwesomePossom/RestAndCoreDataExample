//
//  GeoName+CoreDataProperties.swift
//  CodeOasisAssigment
//
//  Created by Dan Fechtmann on 20/10/2018.
//  Copyright © 2018 Dan Fechtmann. All rights reserved.
//
//

import Foundation
import CoreData


extension GeoName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeoName> {
        return NSFetchRequest<GeoName>(entityName: "GeoName")
    }

    @NSManaged public var countryCode: String?
    @NSManaged public var elevation: Int32
    @NSManaged public var feature: String?
    @NSManaged public var geoNameId: Int32
    @NSManaged public var lang: String?
    @NSManaged public var lat: Float
    @NSManaged public var lng: Float
    @NSManaged public var rank: Int32
    @NSManaged public var summary: String?
    @NSManaged public var thumbnailImg: String?
    @NSManaged public var wikipediaUrl: String?

}
