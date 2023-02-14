//
//  SongCellViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SongCellViewModel: NSObject {
    
    let text: String
    let isRight: Bool
    let level: Int
    let id: Int
    var cash: Int
    var cashAd: Int
    let withdrawLevel: Int
    let withdrawLevelAll: Int
    let isWithdraw: Bool
    let isAd: Bool!
    let isShowDelete = BehaviorRelay<Bool>(value: false)
    let isShowCompletion = BehaviorRelay<Bool>(value: false)
    let isShowSelected = BehaviorRelay<Bool>(value: false)
    let isShowLabelAnimation = BehaviorRelay<Bool>(value: false)
    let selected = PublishRelay<SongCellViewModel>()
    
    init(text: String, isRight: Bool, level: Int, id: Int, cash: Int, withdrawLevel: Int, withdrawLevelAll: Int, isWithdraw: Bool, isAd: Bool, cashAd: Int) {
        self.text = text
        self.isRight = isRight
        self.level = level
        self.id = id
        self.cash = cash
        self.withdrawLevel = withdrawLevel
        self.withdrawLevelAll = withdrawLevelAll
        self.isWithdraw = isWithdraw
        self.isAd = isAd
        self.cashAd = cashAd
    }
}
