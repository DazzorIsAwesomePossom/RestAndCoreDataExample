//
//  CONetworking.swift
//  CodeOasisAssigment
//
//  Created by Dan Fechtmann on 18/10/2018.
//  Copyright © 2018 Dan Fechtmann. All rights reserved.
//

import Foundation

final class CONetworking {
    
    fileprivate let QUERY_URL = "http://api.geonames.org/wikipediaSearchJSON?maxRows=10&username=tingz&q="
    fileprivate let urlSession = URLSession.shared

    
    func queryWikipediaBy(keywords: String, onComplete:@escaping (_ data: Data?,_ response: URLResponse?,_ e: Error?)->()) {
        let formatedKeywords = keywords.replacingOccurrences(of: " ", with: "%20")
        let urlll = QUERY_URL + formatedKeywords
        print(urlll)
        let currentQueryURL = URL(string: urlll)

        var queryRequest = URLRequest(url: currentQueryURL!)
        queryRequest.httpMethod = "GET"
        urlSession.dataTask(with: queryRequest) { (data, response, error) in
           onComplete(data,response, error)
        }.resume()
    }
    
    
}
