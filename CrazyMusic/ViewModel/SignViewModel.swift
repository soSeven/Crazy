//
//  SignViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import RxDataSources

class SignViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Void>
        var requestRedBag: Observable<SignListCellViewModel>
        var requestDouble: Observable<Void>
    }
    
    struct Output {
        let success: PublishSubject<SignActiveModel?>
        let list: BehaviorRelay<[SectionModel<String, SignListCellViewModel>]>
        let openRedBag: PublishSubject<SignListCellViewModel>
        let redBagSuccess: PublishSubject<SignActiveModel?>
        let doubleSuccess: PublishSubject<SignActiveModel?>
        let openCash: PublishSubject<SignListCellViewModel>
    }
    
    func transform(input: Input) -> Output {
        
        let openRedBag = PublishSubject<SignListCellViewModel>()
        let openCash = PublishSubject<SignListCellViewModel>()

        let items = UserManager.shared.login.value.0?.activeList.map({ (m) -> SignListCellViewModel in
            let vm = SignListCellViewModel(model: m)
            vm.openRedBag.bind(to: openRedBag).disposed(by: rx.disposeBag)
            vm.openCash.bind(to: openCash).disposed(by: rx.disposeBag)
            return vm
        }) ?? []
        let today = items.filter{ $0.isToday.value > 0 }.first
        
        let success = PublishSubject<SignActiveModel?>()
        input.request.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.requestCoin().subscribe(onNext: { m in
                today?.isActive.accept(1)
                success.onNext(m)
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        let redBagsuccess = PublishSubject<SignActiveModel?>()
        input.requestRedBag.subscribe(onNext: { [weak self] vm in
            guard let self = self else { return }
            self.requestRedBag(day: vm.day.value).subscribe(onNext: { m in
                vm.cash.accept(m?.cash ?? 0)
                if let u = UserManager.shared.user, let cash = m?.cash {
                    u.cash += cash
                    UserManager.shared.login.accept((u, .change))
                }
                redBagsuccess.onNext(m)
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        let doubleSuccess = PublishSubject<SignActiveModel?>()
        input.requestDouble.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if let t = today {
                MobClick.event("sign_gold", attributes: [
                    "day": t.day.value
                ])
            }
            self.requestDoubleCoin().subscribe(onNext: { m in
                doubleSuccess.onNext(m)
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        let section1 = SectionModel<String, SignListCellViewModel>(model: "签到", items: items)
        let list = BehaviorRelay<[SectionModel<String, SignListCellViewModel>]>(value: [section1])

        return Output(success: success,
                      list: list,
                      openRedBag: openRedBag,
                      redBagSuccess: redBagsuccess,
                      doubleSuccess: doubleSuccess,
                      openCash: openCash)
    }
    
    // MARK: - Request
    
    func requestCoin() -> Observable<SignActiveModel?> {
        
        return NetManager.requestObj(.signSingle, type: SignActiveModel.self).trackError(error).trackActivity(loading)
        
    }
    
    func requestDoubleCoin() -> Observable<SignActiveModel?> {
        
        return NetManager.requestObj(.signDouble, type: SignActiveModel.self).trackError(error).trackActivity(loading)
        
    }
    
    func requestRedBag(day: Int) -> Observable<SignActiveModel?> {
        
        return NetManager.requestObj(.signRedBag(day: day), type: SignActiveModel.self).trackError(error).trackActivity(loading)
        
    }
    
    
}
