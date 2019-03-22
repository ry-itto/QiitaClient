//
//  LoginViewController.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/21.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

final class LoginViewController: WebViewController {
    
    static let shared = LoginViewController()
    let service: QiitaAccountServiceProtocol = QiitaAccountService()
    
    private let modalEvent = ModalEventWrapper.instance
    
    private init() {
        let url = QiitaAPIGateway.shared.authorizeURL
        super.init(url: url!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if webView.url?.absoluteString.contains(QiitaConfig.shared.redirectURL.absoluteString) ?? false {
            decisionHandler(.cancel)
            service.fetchAccessToken(from: webView.url!)
            modalEvent.loginModalClose.accept(self)
        } else {
            decisionHandler(.allow)
        }
    }
}
