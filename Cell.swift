//
//  Cell.swift
//  Instagram
//
//  Created by geine on 15/2/28.
//  Copyright (c) 2015年 isee. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    @IBOutlet var PostedImage: UIImageView!
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var UsernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
