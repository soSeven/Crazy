//
//  DiamondRedBagViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

class DiamondRedBagViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Void>
    }
    
    struct Output {
        let success: PublishSubject<DiamondRedBagModel?>
    }
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<DiamondRedBagModel?>()
        
        input.request.subscribe(onNext: { [weak self] j in
            guard let self = self else { return }
            self.request().subscribe(onNext: { m in
                success.onNext(m)
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success)
    }
    
    // MARK: - Request
    
    func request() -> Observable<DiamondRedBagModel?> {
        
        return NetManager.requestObj(.diamondCashRedBag, type: DiamondRedBagModel.self).trackError(error).trackActivity(loading)
        
    }
    
    
}
