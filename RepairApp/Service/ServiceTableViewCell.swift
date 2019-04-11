//
//  ServiceTableViewCell.swift
//  RepairApp
//
//  Created by Victor on 27/2/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    var service:Service!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setServices(service:Service) {
        self.service = service
        lblServiceName.text = service.name
        lblCategory.text = "Category: \(service.category)"
        lblStatus.text = service.status
        if(service.status == "Pending") {
            lblStatus.textColor = UIColor.red
        } else if(service.status == "In Progress"){
            lblStatus.textColor = UIColor.orange
        } else {
            lblStatus.textColor = UIColor.green
        }
    }
}
