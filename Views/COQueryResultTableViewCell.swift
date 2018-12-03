//
//  COQueryResultTableViewCell.swift
//  CodeOasisAssigment
//
//  Created by Dan Fechtmann on 20/10/2018.
//  Copyright © 2018 Dan Fechtmann. All rights reserved.
//

import UIKit

class COQueryResultTableViewCell: UITableViewCell, TableViewCellCreateSelf {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createSelf(geoName: COGeoName) -> COQueryResultTableViewCell {
        titleLabel.text = geoName.title!
        summaryLabel.text = geoName.summary!
        
        return self
    }

}
