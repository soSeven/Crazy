//
//  VideoCoordinator.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/11.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import Swinject

class VideoCoordinator: Coordinator {
    
    var tabItem: UITabBarItem
    var tabBarController: UITabBarController
    var container: Container
    
    init(container: Container, tabBarController: UITabBarController, tabItem: UITabBarItem) {
        self.container = container
        self.tabBarController = tabBarController
        self.tabItem = tabItem
    }
    
    func start() {
        let video = container.resolve(VideoViewController.self)!
        video.tabBarItem = tabItem
        tabBarController.addChild(video)
    }
    
    
}
