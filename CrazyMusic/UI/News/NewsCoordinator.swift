//
//  NewsCoordinator.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/6.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import Swinject

class NewsCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var container: Container
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let news = container.resolve(WebViewController.self)!
        news.url = URL(string: "http://news.sjggk.cn/news/dynamicUrl?urlKey=KEY1211373927")
        news.needGoBack = true
        navigationController.pushViewController(news, animated: true)
    }
    
    
}
