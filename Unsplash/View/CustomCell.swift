//
//  CustomCell.swift
//  Unsplash
//
//  Created by mmxsound on 2020/08/10.
//  Copyright © 2020 mmxsound. All rights reserved.
//

import UIKit

class CustomCell : UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
    }
    
    public func configureCell(imgUrl: String?) {
        if let url = imgUrl {
            imgView.downloaded(from: url)
        }
    }
}
