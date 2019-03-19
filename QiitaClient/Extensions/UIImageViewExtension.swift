//
//  UIImageViewExtension.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/20.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImageFrom(url: URL?, placeholder: UIImage?) {
        guard let url = url else { return }
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
