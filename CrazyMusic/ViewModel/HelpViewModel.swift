//
//  HelpViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

class HelpViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<(String?, String?)>
    }
    
    struct Output {
        let success: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<String>()
        
        input.request.subscribe(onNext: { [weak self] c, p in
            guard let self = self else { return }
            self.request(content: c ?? "", phone: p ?? "").subscribe(onNext: { _ in
                success.onNext("反馈成功")
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success)
    }
    
    // MARK: - Request
    
    func request(content: String, phone: String) -> Observable<Void> {
        
        return NetManager.requestResponse(.help(content: content, phone: phone)).trackError(error).trackActivity(loading)
        
    }
    
    
}
