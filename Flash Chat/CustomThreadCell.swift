//
//  CustomThreadCell.swift
//  Flash Chat
//
//  Created by jesus jimenez on 4/2/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class CustomThreadCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
