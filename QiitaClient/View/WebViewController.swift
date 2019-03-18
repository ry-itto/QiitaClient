//
//  WebViewController.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/18.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    let url: URL
    let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
