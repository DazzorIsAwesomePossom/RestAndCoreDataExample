//
//  ViewController.swift
//  CodeOasisAssigment
//
//  Created by Dan Fechtmann on 18/10/2018.
//  Copyright © 2018 Dan Fechtmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var switchLocalWeb: UISegmentedControl!
    @IBOutlet weak var queryResultTableView: UITableView!
    
    private let CELL_IDENTIFIER = "queryCell"
    
    var queryResultDataSource: COQueryResultTableViewDataSource?
    var communicator = CODataCommunicator.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supplyDelegates()
    }

    
    func onSuccess(names: COGeoNames?) {
        DispatchQueue.main.async {
            self.queryResultDataSource?.queryCompleted(geoNames: names!.geonames!)
            self.queryResultTableView.reloadData()
        }
    }
    
    
    func onFail(e: Error) {
        print(e)
    }
    
    
    func createCell(geoName: COGeoName, tableView: UITableView) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as! COQueryResultTableViewCell
        let cellToReturn = cell.createSelf(geoName: geoName)
        return cellToReturn
    }

    
    private func supplyDelegates() {
        
        queryResultDataSource = COQueryResultTableViewDataSource(createCellFunc: createCell)
        queryResultTableView.dataSource = queryResultDataSource
        searchBar.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchedKeywords = searchBar.text!
        switch switchLocalWeb.selectedSegmentIndex {
        case 0:
            communicator.queryWebFor(keyword: searchedKeywords, onSuccess: onSuccess, onFail: onFail)
            break;
        case 1:
            communicator.queryLocal(keywords: searchedKeywords, onSuccess: onSuccess, onFail: onFail)
            break;
        default:
            break;
        }
        searchBar.resignFirstResponder()
    }


}

