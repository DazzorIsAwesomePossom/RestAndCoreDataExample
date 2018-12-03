//
//  CODataCommunicator.swift
//  CodeOasisAssigment
//
//  Created by Dan Fechtmann on 18/10/2018.
//  Copyright © 2018 Dan Fechtmann. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class CODataCommunicator  {
    
    fileprivate let ENTITY_NAME = "GeoName"
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let networkingInstance = CONetworking()
    fileprivate var managedGeoNames: [NSManagedObject]?
    
    fileprivate var persistentContainer: NSManagedObjectContext?
    
    static let shared = CODataCommunicator()
    
    private init (){
        
        
    }
    
    func queryWebFor(keyword: String, onSuccess:@escaping (_ geoNames: COGeoNames?)->(), onFail:@escaping (_ e: Error)->()) {

        networkingInstance.queryWikipediaBy(keywords: keyword) { (data, response, error) in
            if let e = error {
                onFail(e)
            }
            guard let geoNames = self.queryWebComplete(response: response!, data: data!, onFail: onFail)
                else {
                    onFail(CODataCommunicatorError.FailedToParseJSON)
                    return
            }
            onSuccess(geoNames)
        }
        
    }
    
    
    func queryLocal(keywords: String,  onSuccess:@escaping (_ geoNames: COGeoNames?)->(), onFail:@escaping (_ e: Error)->()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let managedContext = COCoreDataStack.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.ENTITY_NAME)
            let predicateTitle = NSPredicate(format: "title CONTAINS[cd] %@", keywords)
            let predicateSummary = NSPredicate(format: "summary CONTAINS[cd] %@", keywords)
            let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateTitle, predicateSummary])
            var geonameLocalResults : [NSManagedObject] = []
            
            fetchRequest.predicate = compundPredicate
            
            do {
                geonameLocalResults = try managedContext.fetch(fetchRequest)
                self.queryLocalComplete(managedObjects: geonameLocalResults, onSuccess: onSuccess)
            }
            catch {
                DispatchQueue.main.async {
                    onFail(error)
                }
            }
        }
        
    }

    
    private func queryWebComplete(response: URLResponse, data:Data, onFail:@escaping (_ e: Error)->()) -> COGeoNames? {
        
        let geoNamesToReturn = parseJSONToModel(response: response, data: data, onFail: onFail)
        DispatchQueue.global(qos: .userInitiated).async {
            self.parseModelToManagedModel(names: geoNamesToReturn, onFail: onFail)
        }
        return geoNamesToReturn
        
    }
    
    
    private func queryLocalComplete(managedObjects: [NSManagedObject], onSuccess:@escaping (_ geoNames: COGeoNames?)->()) {
        
        let parsedManagedModelToModel = parseManagedModelToModel(managedObjects: managedObjects)
        DispatchQueue.main.async {
            onSuccess(parsedManagedModelToModel)
        }
        
    }
    
    private func parseManagedModelToModel(managedObjects: [NSManagedObject]) -> COGeoNames {
        
        var geoNamesToReturn: COGeoNames = COGeoNames()
        
        for managedObject in managedObjects {
            
            let newGeoName = COGeoName()
            newGeoName.countryCode = managedObject.value(forKey: COManagedObjectKeys.countryCode.rawValue) as? String
            newGeoName.elevation = managedObject.value(forKey: COManagedObjectKeys.elevation.rawValue) as? Int
            newGeoName.feature = managedObject.value(forKey: COManagedObjectKeys.feature.rawValue) as? String
            newGeoName.geoNameId = managedObject.value(forKey: COManagedObjectKeys.geoNameId.rawValue) as? Int
            newGeoName.lang = managedObject.value(forKey: COManagedObjectKeys.lang.rawValue) as? String
            newGeoName.lat = managedObject.value(forKey: COManagedObjectKeys.lat.rawValue) as? Float
            newGeoName.lng = managedObject.value(forKey: COManagedObjectKeys.lng.rawValue) as? Float
            newGeoName.rank = managedObject.value(forKey: COManagedObjectKeys.rank.rawValue) as? Int
            newGeoName.summary = managedObject.value(forKey: COManagedObjectKeys.summary.rawValue) as? String
            newGeoName.thumbnailImg = managedObject.value(forKey: COManagedObjectKeys.thumbnailImg.rawValue) as? String
            newGeoName.title = managedObject.value(forKey: COManagedObjectKeys.title.rawValue) as? String
            newGeoName.wikipediaUrl = managedObject.value(forKey: COManagedObjectKeys.wikipediaUrl.rawValue) as? String
            geoNamesToReturn.geonames?.append(newGeoName)
            
        }
        
        return geoNamesToReturn
        
    }
    
    private func parseModelToManagedModel(names: COGeoNames?,  onFail:@escaping (_ e: Error)->()) {
        
        let managedContext = COCoreDataStack.shared.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: ENTITY_NAME, in: managedContext)
        for name in names!.geonames! {
            let managedGeo = NSManagedObject(entity: entityDescription!, insertInto: managedContext)
            managedGeo.setValue(name.countryCode, forKey: COManagedObjectKeys.countryCode.rawValue)
            managedGeo.setValue(name.elevation, forKey: COManagedObjectKeys.elevation.rawValue)
            managedGeo.setValue(name.feature, forKey: COManagedObjectKeys.feature.rawValue)
            managedGeo.setValue(name.geoNameId, forKey: COManagedObjectKeys.geoNameId.rawValue)
            managedGeo.setValue(name.lang, forKey: COManagedObjectKeys.lang.rawValue)
            managedGeo.setValue(name.lat, forKey: COManagedObjectKeys.lat.rawValue)
            managedGeo.setValue(name.lng, forKey: COManagedObjectKeys.lng.rawValue)
            managedGeo.setValue(name.rank, forKey: COManagedObjectKeys.rank.rawValue)
            managedGeo.setValue(name.summary, forKey: COManagedObjectKeys.summary.rawValue)
            managedGeo.setValue(name.thumbnailImg, forKey: COManagedObjectKeys.thumbnailImg.rawValue)
            managedGeo.setValue(name.title, forKey: COManagedObjectKeys.title.rawValue)
            managedGeo.setValue(name.wikipediaUrl, forKey: COManagedObjectKeys.wikipediaUrl.rawValue)
            do {
                try managedContext.save()
            }
            catch {
                onFail(error)
            }
        }
        
    }
    
    private func parseJSONToModel(response: URLResponse, data:Data, onFail:@escaping (_ e: Error)->()) -> COGeoNames? {
        
        let decoder =  JSONDecoder()
        var geoNamesParsed: COGeoNames?
        do {
            geoNamesParsed = try decoder.decode(COGeoNames.self, from: data)
            return geoNamesParsed!
        }
        catch {
            onFail(error)
        }
        return geoNamesParsed
        
    }
    
    private func queryFailed(e: Error) {
        
        
        
    }
    
}


enum CODataCommunicatorError: Error {
    
    case FailedToParseJSON
    
}

enum COManagedObjectKeys: String {
    
    case summary = "summary"
    case elevation = "elevation"
    case geoNameId = "geoNameId"
    case feature = "feature"
    case lng = "lng"
    case countryCode = "countryCode"
    case rank = "rank"
    case thumbnailImg = "thumbnailImg"
    case lang = "lang"
    case title = "title"
    case lat = "lat"
    case wikipediaUrl = "wikipediaUrl"
    
}
