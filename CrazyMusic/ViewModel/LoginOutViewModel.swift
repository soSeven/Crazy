//
//  LoginOutViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

class LoginOutViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Void>
    }
    
    struct Output {
        let success: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<String>()
        
        input.request.subscribe(onNext: { [weak self] j in
            guard let self = self else { return }
            self.request().subscribe(onNext: { _ in
                success.onNext("注销成功")
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success)
    }
    
    // MARK: - Request
    
    func request() -> Observable<Void> {
        
        return NetManager.requestResponse(.loginOut).trackError(error).trackActivity(loading)
        
    }
    
    
}
