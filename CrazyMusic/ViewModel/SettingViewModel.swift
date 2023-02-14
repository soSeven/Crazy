//
//  SettingViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum SettingType: String {
    case userProtocol = "用户协议"
    case userPrivacy = "隐私政策"
    case question = "问题反馈"
    case deleteUser = "注销账户"
    case update = "版本更新"
}

class SettingViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Void>
    }
    
    struct Output {
        var items: BehaviorRelay<[SettingType]>
    }
    
    func transform(input: Input) -> Output {
        
        let items = BehaviorRelay<[SettingType]>(value: [
            .userProtocol,
            .userPrivacy,
            .question,
            .deleteUser,
            .update
        ])

        return Output(items: items)
    }
    
    
}
