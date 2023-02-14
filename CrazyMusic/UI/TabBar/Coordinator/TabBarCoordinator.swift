//
//  AppCoordinator.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject

enum TabBarChildCoordinator {
    case home
    case video
    case news
    case mine
}

final class TabBarCoordinator: Coordinator {
    
    // MARK: - Properties
    let container: Container
    private let window: UIWindow
    private var tabBarController: TabBarController?
    private var childCoordinators = [TabBarChildCoordinator:Coordinator]()
    
    
    init(window: UIWindow, container: Container) {
        self.container = container
        self.window = window
    }
    
    func start() {
        tabBarController = container.resolve(TabBarController.self, argument: self)
        window.rootViewController = tabBarController
    }
    
}

extension TabBarCoordinator: TabBarControllerDelegate {
    
    func showChildControllers(tabController: TabBarController, items: [TabBarItem]) {
        for item in items {
            switch item {
            case .home:
                showHome(tabController: tabController)
            case .mine:
                showMine(tabController: tabController)
            case .video:
                showVideo(tabController: tabController)
            case .news:
                showNews(tabController: tabController)
            }
        }
    }
    
    func showHome(tabController: TabBarController) {
        let nav = NavigationController()
        let tabItem = UITabBarItem(title: nil, image: UIImage(named: "tab_icon01_nor")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_icon01_sel")?.withRenderingMode(.alwaysOriginal))
        tabItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        tabItem.tag = 0
        nav.tabBarItem = tabItem
        let homeCoordinator = HomeCoordinator(container: container, navigationController: nav)
        homeCoordinator.start()
        childCoordinators[.home] = homeCoordinator
        tabController.addChild(nav)
        
    }
    
    func showVideo(tabController: TabBarController) {
//        let nav = NavigationController()
        let tabItem = UITabBarItem(title: nil, image: UIImage(named: "tab_icon02_nor")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_icon02_sel")?.withRenderingMode(.alwaysOriginal))
        tabItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        tabItem.tag = 1
        let videoCoordinator = VideoCoordinator(container: container,
                                                tabBarController: tabController,
                                                tabItem: tabItem)
        videoCoordinator.start()
        childCoordinators[.video] = videoCoordinator
//        tabController.addChild(nav)
        
    }
    
    func showNews(tabController: TabBarController) {
        let nav = NavigationController()
        let tabItem = UITabBarItem(title: nil, image: UIImage(named: "tab_icon03_nor")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_icon03_sel")?.withRenderingMode(.alwaysOriginal))
        tabItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        tabItem.tag = 2
        nav.tabBarItem = tabItem
        let mineCoordinator = NewsCoordinator(container: container, navigationController: nav)
        mineCoordinator.start()
        childCoordinators[.news] = mineCoordinator
        tabController.addChild(nav)
        
    }
    
    func showMine(tabController: TabBarController) {
        let nav = NavigationController()
        let tabItem = UITabBarItem(title: nil, image: UIImage(named: "tab_icon04_nor")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_icon04_sel")?.withRenderingMode(.alwaysOriginal))
        tabItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        tabItem.tag = 3
        nav.tabBarItem = tabItem
        let mineCoordinator = MineCoordinator(container: container, navigationController: nav)
        mineCoordinator.start()
        childCoordinators[.mine] = mineCoordinator
        tabController.addChild(nav)
        
    }
    
    
}
