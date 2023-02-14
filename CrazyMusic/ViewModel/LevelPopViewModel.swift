//
//  LevelPopViewModel.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt

class LevelPopViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let request: Observable<Int>
    }
    
    struct Output {
        let list: BehaviorRelay<[LevelPopCellViewModel]>
        let openCoinSuccess: PublishSubject<GoldActiveModel?>
    }

    func transform(input: Input) -> Output {
        
        let list = BehaviorRelay<[LevelPopCellViewModel]>(value: [])
        let openCoin = PublishSubject<LevelPopCellViewModel>()
        let openCoinSuccess = PublishSubject<GoldActiveModel?>()
        
        input.request.subscribe(onNext: { [weak self] level in
            guard let self = self else { return }
            let items = UserManager.shared.user?.goldList ?? []
            let vItems = items.map { m -> LevelPopCellViewModel in
                let vm = LevelPopCellViewModel(model: m)
                if m.type == 1 && m.level <= level {
                    vm.type.accept(2)
                }
                vm.openCoin.bind(to: openCoin).disposed(by: self.rx.disposeBag)
                return vm
            }
            list.accept(vItems)
        }).disposed(by: rx.disposeBag)
        
        openCoin.subscribe(onNext: { [weak self] vm in
            guard let self = self else { return }
            self.request(level: vm.level.value).subscribe(onNext: { m in
                if let u = UserManager.shared.user, let m = m {
                    u.gold += m.gold
                    UserManager.shared.login.accept((u, .change))
                }
                vm.type.accept(3)
                openCoinSuccess.onNext(m)
            }, onError: { error in

            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(list: list, openCoinSuccess: openCoinSuccess)
    }
    
    // MARK: - Request
    
    func request(level: Int) -> Observable<GoldActiveModel?> {
        
        return NetManager.requestObj(.goldTask(level: level), type: GoldActiveModel.self).trackError(error).trackActivity(loading)
        
    }
    
    
}
