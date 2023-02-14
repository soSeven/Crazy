//
//  HomeCoordinator.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/6.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import Swinject

class HomeCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var container: Container
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let home = container.resolve(HomeViewController.self)!
        home.delegate = self
        navigationController.pushViewController(home, animated: true)
    }
    
}

extension HomeCoordinator: HomeViewControllerDelegate {
    
    func homeDidSelectedCash(controller: HomeViewController, level: Int?) {
        
        let cash = container.resolve(GetCashViewController.self)!
        cash.currentLevel = level ?? 0
        cash.delegate = self
        navigationController.pushViewController(cash)
    }
    
    func homeDidSelectedMine(controller: HomeViewController) {
        if UserManager.shared.isCheck {
            return
        }
        
        let setting = container.resolve(SettingViewController.self)!
        setting.delegate = self
        navigationController.pushViewController(setting, animated: true)
    }
    
    
}

extension HomeCoordinator: SettingViewControllerDelegate {
    
    func settingShowType(controller: SettingViewController, type: SettingType) {
        let u = UserManager.shared.configure?.page
        switch type {
        case .userPrivacy:
            let web = container.resolve(WebViewController.self)!
            web.url = URL(string: u?.privacyPolicy)
            navigationController.pushViewController(web)
        case .userProtocol:
            let web = container.resolve(WebViewController.self)!
            web.url = URL(string: u?.userAgreement)
            navigationController.pushViewController(web)
        case .deleteUser:
            let web = container.resolve(WebViewController.self)!
            web.url = URL(string: u?.userLogoutAgreement)
            navigationController.pushViewController(web)
        case .question:
            let help = container.resolve(HelpViewController.self)!
            navigationController.pushViewController(help)
        default:
            break
        }
    }
    
}

extension HomeCoordinator: GetCashViewControllerDelegate {
    
    func cashSelectedPlayMusic(controller: GetCashViewController) {
        navigationController.popToRootViewController(animated: true)
    }
    
    func cashSelectedGetCash(controller: GetCashViewController) {
        let cash = container.resolve(GetCashViewController.self)!
        cash.delegate = self
        navigationController.pushViewController(cash)
    }
    
    func cashSelectedProtocol(controller: GetCashViewController) {
        let u = UserManager.shared.configure?.page
        let web = container.resolve(WebViewController.self)!
        web.url = URL(string: u?.settlementAgreement)
        navigationController.pushViewController(web)
    }
    
    func cashSelectedRecord(controller: GetCashViewController) {
        let record = container.resolve(CashRecordViewController.self)!
        navigationController.pushViewController(record)
    }
    
}

