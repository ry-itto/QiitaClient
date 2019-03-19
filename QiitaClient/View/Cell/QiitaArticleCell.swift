//
//  QiitaArticleCell.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/15.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

class QiitaArticleCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: type(of: self))
    static let rowHeight = CGFloat(92)
    
    @IBOutlet var thumbnailImage: UIImageView!
    @IBOutlet var title: UILabel! {
        didSet {
            title.numberOfLines = 2
            title.lineBreakMode = .byTruncatingTail
            title.sizeToFit()
        }
    }
    @IBOutlet var userName: UILabel!
    @IBOutlet var goodCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: Trend.TrendArticle) {
        self.thumbnailImage.setImageFrom(url: model.node.author.profileImageUrl, placeholder: UIImage(named: "people"))
        self.title.text = model.node.title
        self.userName.text = model.node.author.urlName
        self.goodCount.text = "\(model.node.likesCount)"
    }
    
    func configure(model: QiitaAPI.Article) {
        self.thumbnailImage.setImageFrom(url: model.user.profileImageUrl, placeholder: UIImage(named: "people"))
        self.title.text = model.title
        self.userName.text = "by \(model.user.id)"
        self.goodCount.text = "いいね: \(model.likesCount)"
    }
}
