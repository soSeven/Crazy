//
//  LevelPopCellViewModel.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LevelPopCellViewModel: NSObject {
    
    let level = BehaviorRelay<Int>(value: 0)
    let gold = BehaviorRelay<Int>(value: 0)
    let type = BehaviorRelay<Int>(value: 0)
    let openCoin = PublishSubject<LevelPopCellViewModel>()
    
    init(model: GoldListModel) {
        super.init()
        level.accept(model.level)
        gold.accept(model.gold)
        type.accept(model.type)
        type.subscribe(onNext: { type in
            model.type = type
        }).disposed(by: rx.disposeBag)
    }
}
