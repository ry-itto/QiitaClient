//
//  AuthenticatedUserProfileViewController.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/30.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthenticatedUserProfileViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 5
            descriptionLabel.lineBreakMode = .byTruncatingTail
            descriptionLabel.sizeToFit()
        }
    }
    
    let viewModel = AuthenticatedUserViewModelViewModel()
    
    static func instantiateWithTabBarItem() -> UINavigationController {
        let viewController = UINavigationController(rootViewController: AuthenticatedUserProfileViewController())
        viewController.title = "プロフィール"
        viewController.tabBarItem.image = UIImage(named: "people")
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad.onNext(())
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func bindViewModel() {
        viewModel.fetchUserInfo
            .subscribe(onNext: { [weak self] user in
                self?.setToOutlets(user: user)
            }).disposed(by: disposeBag)
    }
    
    private func setToOutlets(user: QiitaAPI.AuthenticatedUserInfo) {
        self.profileImageView.image = fetchImageFromURL(url: user.profileImageUrl)
        self.userIdLabel.text = "@\(user.id)"
        self.userNameLabel.text = user.name
        self.descriptionLabel.text = user.description
    }
    
    fileprivate func fetchImageFromURL(url: URL?) -> UIImage? {
        guard
            let url = url,
            let data = try? Data(contentsOf: url) else { return nil }
        
        return UIImage(data: data)
    }
}
