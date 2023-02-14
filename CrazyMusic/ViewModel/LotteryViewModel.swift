//
//  LotteryViewModel.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/17.
//  Copyright © 2020 LQ. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt

class LotteryViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let request: Observable<Int>
        let requestLottery: Observable<Void>
    }
    
    struct Output {
        let success: PublishSubject<LotteryListModel>
        let listFailure: PublishSubject<Void>
        let step: PublishSubject<Void>
        let lotteryFinished: PublishSubject<LotteryModel?>
        let lotteryError: PublishSubject<Void>
    }

    func transform(input: Input) -> Output {
        
        let success = PublishSubject<LotteryListModel>()
        let listFailure = PublishSubject<Void>()
        
        input.request.subscribe(onNext: { [weak self] j in
            guard let self = self else { return }
            self.requestList(type: j).subscribe(onNext: { m in
                guard let m = m, m.items.count >= 4 else {
                    listFailure.onNext(())
                    return
                }
                if let u = UserManager.shared.login.value.0 {
                    u.isWithdraw = false
                    UserManager.shared.login.accept((u, .change))
                }
                success.onNext(m)
            }, onError: { error in
                listFailure.onNext(())
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        let step = PublishSubject<Void>()
        let lotteryFinished = PublishSubject<LotteryModel?>()
        let lotteryError = PublishSubject<Void>()
        input.requestLottery.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let finished = PublishSubject<Void>()
            var disposeBag = DisposeBag()
            let firstTime = Int.random(in: 1000...4000)
            Observable<Int>.interval(.milliseconds(50), scheduler: MainScheduler.instance).subscribe(onNext: { i in
                if firstTime < i * 50 {
                    finished.onNext(())
                    disposeBag = DisposeBag()
                    return
                }
                step.onNext(())
            }).disposed(by: disposeBag)
            Observable.zip(finished.asObserver(), self.requestLottery()).subscribe(onNext: { (_, m) in
                guard let m = m else {
                    lotteryError.onNext(())
                    return
                }
                if let u = UserManager.shared.login.value.0 {
                    if m.type == 2{
                        u.cash += m.num
                    } else if m.type == 3 {
                        u.gold += m.num
                    } else {
                        u.withdrawChance = true
                        u.withdrawExpirationTime.accept(UserManager.shared.configure?.songAd.expirationTime ?? 0)
                        u.withdrawCash = m.num
                    }
                    UserManager.shared.login.accept((u, .change))
                }
                lotteryFinished.onNext(m)
            }, onError: { _ in
                lotteryError.onNext(())
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success, listFailure: listFailure, step: step, lotteryFinished:lotteryFinished, lotteryError: lotteryError)
    }
    
    // MARK: - Request
    
    func requestList(type: Int) -> Observable<LotteryListModel?> {
        
        return NetManager.requestObj(.lotteryList(type: type), type: LotteryListModel.self).trackError(error).trackActivity(loading)
        
    }
    
    func requestLottery() -> Observable<LotteryModel?> {
        
        return NetManager.requestObj(.lottery, type: LotteryModel.self).trackError(error)
        
    }
    
    
}
