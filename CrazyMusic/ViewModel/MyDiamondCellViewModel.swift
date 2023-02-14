//
//  MyDiamondCellViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MyDiamondCellViewModel {
    
    let gold = BehaviorRelay<Int>(value: 0)
    let id = BehaviorRelay<Int>(value: 0)
    let isReceive = BehaviorRelay<Int>(value: 0)
    let isSuccess = BehaviorRelay<Int>(value: 0)
    let level = BehaviorRelay<Int>(value: 0)
    let levelToday = BehaviorRelay<Int>(value: 0)
    let openRedBag = PublishSubject<MyDiamondCellViewModel>()
    let moreLevel = BehaviorRelay<Int>(value: 0)
    
    init(model: MyDiamondListModel) {
        gold.accept(model.gold)
        id.accept(model.id)
        isReceive.accept(model.isReceive)
        isSuccess.accept(model.isSuccess)
        level.accept(model.level)
        levelToday.accept(model.levelToday)
        moreLevel.accept(model.moreLevel)
    }
}
