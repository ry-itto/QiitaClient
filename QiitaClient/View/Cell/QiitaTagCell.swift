//
//  QiitaTagCell.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/20.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

class QiitaTagCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: type(of: self))
    static let rowHeight = CGFloat(50)
    
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var tagNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ model: QiitaAPI.TagInfo) {
        self.tagImageView.setImageFrom(url: model.iconUrl, placeholder: UIImage(named: "missing_tag_image"))
        self.tagNameLabel.text = model.id
    }
}
