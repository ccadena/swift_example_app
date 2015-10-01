//
//  CustomTableViewCell.swift
//  iosSearchApp
//
//  Created by Camilo Cadena on 9/28/15.
//  Copyright © 2015 Camilo Cadena. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.iconView.layer.cornerRadius = self.iconView.frame.size.width/2
        self.iconView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
