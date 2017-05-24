//
//  ItemCell.swift
//  DreamLists
//
//  Created by EricDev on 5/22/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configureCell(item: Item) {
        nameLabel.text = item.title
        priceLabel.text = "$\(String(format: "%.2f", item.price))"
        detailLabel.text = item.details
        thumbnail.image = item.toImage?.image as? UIImage
    }

}
