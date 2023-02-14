//
//  Application.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Swinject
import RxCocoa
import RxSwift
//import YLUISDK


final class Application: NSObject {
    
    static let shared = Application()
    internal let container = Container()
    private var appCoordinator: Coordinator!
    var window: UIWindow!
    
    func configureDependencies() {
        
        /// 网页
        container.register(WebViewController.self) { r in
            return WebViewController()
        }
        
        /// 注册tab
        container.register(TabBarViewModel.self) { _ in
            return TabBarViewModel()
        }
        container.register(TabBarController.self) { (r: Resolver, delegate: TabBarCoordinator) in
            let tab = TabBarController(viewModel: r.resolve(TabBarViewModel.self)!, itemDelegate: delegate)
            return tab
        }
        
        container.register(HomeViewModel.self) { _ in
            return HomeViewModel()
        }
        container.register(HomeViewController.self) { r in
            let c = HomeViewController()
            c.viewModel = r.resolve(HomeViewModel.self)!
            return c
        }
        
        container.register(NewsViewController.self) { r in
            return NewsViewController()
        }
        
        container.register(VideoViewController.self) { r in
            return VideoViewController()
        }
        
        container.register(SettingViewModel.self) { r in
            return SettingViewModel()
        }
        container.register(SettingViewController.self) { r in
            let s = SettingViewController()
            s.viewModel = r.resolve(SettingViewModel.self)
            return s
        }
        
        container.register(CashViewModel.self) { r in
            return CashViewModel()
        }
        container.register(GetCashViewController.self) { r in
            let c = GetCashViewController()
            c.viewModel = r.resolve(CashViewModel.self)!
            return c
        }
        
        container.register(ListViewModel<CashRecordModel>.self) { r in
            let v = ListViewModel<CashRecordModel>(service: CashReocrdListService())
            return v
        }
        container.register(CashRecordViewController.self) { r in
            let c = CashRecordViewController()
            c.viewModel = r.resolve(ListViewModel<CashRecordModel>.self)
            return c
        }
        
        container.register(LaunchViewController.self) { r in
            let c = LaunchViewController()
            return c
        }
        
        container.register(HelpViewModel.self) { _ in
            return HelpViewModel()
        }
        container.register(HelpViewController.self) { r in
            let c = HelpViewController()
            c.viewModel = r.resolve(HelpViewModel.self)
            return c
        }
        
    }
    
    func configureMainInterface(in window: UIWindow) {
        
        let launch = container.resolve(LaunchViewController.self)!
        launch.completion = { [weak self] in
            guard let self = self else { return }
            
//            if UserManager.shared.isCheck {
                let nav = NavigationController()
                self.appCoordinator = HomeCoordinator(container: self.container, navigationController: nav)
                self.appCoordinator.start()
                window.rootViewController = nav
//            } else {
//                self.appCoordinator = TabBarCoordinator(window: window, container: self.container)
//                self.appCoordinator.start()
//            }
        }
        window.rootViewController = launch
        
        
    }
    
    
}

