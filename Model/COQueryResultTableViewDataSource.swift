//
//  COQueryResultTableViewDataSource.swift
//  CodeOasisAssigment
//
//  Created by Dan Fechtmann on 20/10/2018.
//  Copyright © 2018 Dan Fechtmann. All rights reserved.
//

import UIKit


final class COQueryResultTableViewDataSource:NSObject ,UITableViewDataSource {

    private var geoNamesToHold: [COGeoName] = []
    var createCellFunc: (_ GeoName: COGeoName, _ tableView: UITableView) -> UITableViewCell?
    
    init(createCellFunc:@escaping (_ geoName: COGeoName, _ tableView: UITableView) -> UITableViewCell) {
        self.createCellFunc = createCellFunc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoNamesToHold.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentGeoName = geoNamesToHold[indexPath.row]
        return createCellFunc(currentGeoName, tableView)!
    }
    
    func queryCompleted(geoNames: [COGeoName]) {
        geoNamesToHold = geoNames
    }
    
}

protocol TableViewCellCreateSelf {
    func createSelf(geoName: COGeoName) -> COQueryResultTableViewCell
}
