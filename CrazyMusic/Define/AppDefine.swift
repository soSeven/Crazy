//
//  AppDefine.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/14.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class AppDefine {
    
    static let isDebug = false
    static let isNeedCrashDebug = false
    
    /// 不显示两倍钻石的关卡
    static let minDoubleRewardLevel = 100000
    
    /// 没有广告的闯关红包关卡
    static let noAdLevel = [5]
    
    /// 显示提现的闯关红包关卡
    static let getCashLevel = [5, 25]
    
    /// 第10关显示提现的提现日
    static let signCashNum = 10
    static let signCashDay = [5, 10, 20, 30]
    
    /// 提现100元的Id
    static let cash100Id = 6
    /// 提现0.3元的Id
    static let cashPoint3Id = 1
    /// 不显示两倍钻石的关卡
    static let cashPoint3LevelMin = 25
    
    static let cashDoubleNumber = 2
    
}


