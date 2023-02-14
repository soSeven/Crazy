//
//  MineCoordinator.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/11.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import Swinject

class MineCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var container: Container
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
//        let mine = container.resolve(MineViewController.self)!
//        mine.delegate = self
//        navigationController.pushViewController(mine, animated: true)
    }
    
}

extension MineCoordinator: GetCashViewControllerDelegate {
    
    func cashSelectedPlayMusic(controller: GetCashViewController) {
        navigationController.popToRootViewController(animated: false)
        if let tabVc = navigationController.tabBarController as? TabBarController {
            tabVc.selecteIndex(0)
        }
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

extension MineCoordinator: SettingViewControllerDelegate {
    
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
