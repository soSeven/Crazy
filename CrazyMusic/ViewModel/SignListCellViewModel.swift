//
//  SignListCellViewModel.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/17.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignListCellViewModel: NSObject {
    
    let day = BehaviorRelay<Int>(value: 0)
    let gold = BehaviorRelay<Int>(value: 0)
    let isActive = BehaviorRelay<Int>(value: 0)
    let text = BehaviorRelay<String>(value: "")
    let cash = BehaviorRelay<Int>(value: 0)
    let isToday = BehaviorRelay<Int>(value: 0)
    let openRedBag = PublishSubject<SignListCellViewModel>()
    let openCash = PublishSubject<SignListCellViewModel>()
    var isWithdraw: Bool!
    
    init(model: SignListModel) {
        super.init()
        
        isWithdraw = model.isWithdraw
        
        gold.accept(model.gold)
        day.accept(model.day)
        isActive.accept(model.isActive)
        text.accept(model.text)
        cash.accept(model.cash)
        isToday.accept(model.isToday)
        
        gold.subscribe(onNext: { gold in
            model.gold = gold
        }).disposed(by: rx.disposeBag)
        
        day.subscribe(onNext: { day in
            model.day = day
        }).disposed(by: rx.disposeBag)
        
        isActive.subscribe(onNext: { isActive in
            model.isActive = isActive
        }).disposed(by: rx.disposeBag)
        
        text.subscribe(onNext: { text in
            model.text = text
        }).disposed(by: rx.disposeBag)
        
        cash.subscribe(onNext: { cash in
            model.cash = cash
        }).disposed(by: rx.disposeBag)
        
        isToday.subscribe(onNext: { isToday in
            model.isToday = isToday
        }).disposed(by: rx.disposeBag)
    }
}
