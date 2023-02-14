//
//  UserModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/15.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

class UserModel: NSObject, Mapable, NSCoding {
    
    var id : String!
    var token : String!
    var isNew : Bool!
    
    var avatar : String!
    var cash : Int!
    var cashLastLevel : Int!
    var cashNum : Int!
    var gold : Int!
    var goldAll : Int!
    var goldToCashNum : Int!
    var goldToday : Int!
    var hp : Int!
    var hpTime : Int!
    var isWeixin : Int!
    var level : Int!
    var levelToday : Int!
    var musicType : Int!
    var nickname : String!
    var sex : Int!
    var signAllNum : Int!
    var signNum : Int!
    var singleNum : Int!
    var status : String!
    var timerCashTime : Int!
    
    /// 是否签到
    var isActive: Bool!
    /// 连续签到天数
    var active: Int!
    /// 总签到天数
    var activeAll: Int!
    /// 翻倍倍数，0-未翻倍
    var activeDouble: Int!
    /// 签到获得的金币数量
    var activeGold: Int!
    
    var activeList: [SignListModel]!
    var song: SongModel!
    
    /// 用户距离下次提现需要的关数
    var withdrawLevel: Int!
    /// 用户提现需要的关数
    var withdrawLevelAll: Int!
    /// 完成此关后还需要完成多少关可提现-实际值
    var withdrawLevelReal: Int!
    /// 完成此关后总共需要多少关提现-实际值
    var withdrawLevelAllReal: Int!
    /// 是否可提现
    var isWithdraw: Bool!
    /// 是否显示提现机会
    var withdrawChance: Bool!
    /// 提现机会剩余时间
    var withdrawExpirationTime = BehaviorRelay<Int>(value: 0)
    /// 提现机会金额
    var withdrawCash: Int!
    
    /// 今日拆红包数量
    var convert: Int!
    
    var channel: String!
    
    var goldList: [GoldListModel]!
    
    required init(json: JSON) {
        
        avatar = json["avatar"].stringValue
        cash = json["cash"].intValue
        cashLastLevel = json["cash_last_level"].intValue
        cashNum = json["cash_num"].intValue
        gold = json["gold"].intValue
        goldAll = json["gold_all"].intValue
        goldToCashNum = json["gold_to_cash_num"].intValue
        goldToday = json["gold_today"].intValue
        hp = json["hp"].intValue
        hpTime = json["hp_time"].intValue
        id = json["id"].stringValue
        isWeixin = json["is_weixin"].intValue
        level = json["level"].intValue
        levelToday = json["level_today"].intValue
        musicType = json["music_type"].intValue
        nickname = json["nickname"].stringValue
        sex = json["sex"].intValue
        signAllNum = json["sign_all_num"].intValue
        signNum = json["sign_num"].intValue
        singleNum = json["single_num"].intValue
        status = json["status"].stringValue
        timerCashTime = json["timer_cash_time"].intValue

        token = json["token"].stringValue
        isNew = json["is_new"].boolValue
        isActive = json["is_active"].boolValue
        activeList = json["active_list"].arrayValue.map{ SignListModel(json: $0) }
        song = SongModel(json: json["song"])
        channel = json["channel"].stringValue
        
        active = json["active"].intValue
        activeAll = json["active_all"].intValue
        activeDouble = json["active_double"].intValue
        activeGold = json["active_gold"].intValue
        
        withdrawLevel = json["withdraw_level"].intValue
        withdrawLevelAll = json["withdraw_level_all"].intValue
        withdrawLevelReal = json["withdraw_level_real"].intValue
        withdrawLevelAllReal = json["withdraw_level_all_real"].intValue
        isWithdraw = json["is_withdraw"].boolValue
        
        convert = json["convert"].intValue
        
        goldList = json["gold_task"].arrayValue.map{ GoldListModel(json: $0) }
        
        withdrawChance = json["withdraw_chance"].boolValue
        withdrawCash = json["withdraw_cash"].intValue
        let withdrawExpirationTimeN = json["withdraw_expiration_time"].intValue
        withdrawExpirationTime.accept(withdrawExpirationTimeN)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(avatar, forKey: "avatar")
        coder.encode(cash, forKey: "cash")
        coder.encode(cashLastLevel, forKey: "cash_last_level")
        coder.encode(cashNum, forKey: "cash_num")
        coder.encode(gold, forKey: "gold")
        coder.encode(goldAll, forKey: "gold_all")
        coder.encode(goldToCashNum, forKey: "gold_to_cash_num")
        coder.encode(goldToday, forKey: "gold_today")
        coder.encode(hp, forKey: "hp")
        coder.encode(hpTime, forKey: "hp_time")
        coder.encode(id, forKey: "id")
        coder.encode(isWeixin, forKey: "is_weixin")
        coder.encode(level, forKey: "level")
        coder.encode(levelToday, forKey: "level_today")
        coder.encode(musicType, forKey: "music_type")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(sex, forKey: "sex")
        coder.encode(signAllNum, forKey: "sign_all_num")
        coder.encode(signNum, forKey: "sign_num")
        coder.encode(singleNum, forKey: "single_num")
        coder.encode(status, forKey: "status")
        coder.encode(timerCashTime, forKey: "timer_cash_time")
        coder.encode(token, forKey: "token")
    }
    
    required init?(coder: NSCoder) {
        avatar = coder.decodeObject(forKey: "avatar") as? String
        cash = coder.decodeObject(forKey: "cash") as? Int
        cashLastLevel = coder.decodeObject(forKey: "cash_last_level") as? Int
        cashNum = coder.decodeObject(forKey: "cash_num") as? Int
        gold = coder.decodeObject(forKey: "gold") as? Int
        goldAll = coder.decodeObject(forKey: "gold_all") as? Int
        goldToCashNum = coder.decodeObject(forKey: "gold_to_cash_num") as? Int
        goldToday = coder.decodeObject(forKey: "gold_today") as? Int
        hp = coder.decodeObject(forKey: "hp") as? Int
        hpTime = coder.decodeObject(forKey: "hp_time") as? Int
        id = coder.decodeObject(forKey: "id") as? String
        isWeixin = coder.decodeObject(forKey: "is_weixin") as? Int
        level = coder.decodeObject(forKey: "level") as? Int
        levelToday = coder.decodeObject(forKey: "level_today") as? Int
        musicType = coder.decodeObject(forKey: "music_type") as? Int
        nickname = coder.decodeObject(forKey: "nickname") as? String
        sex = coder.decodeObject(forKey: "sex") as? Int
        signAllNum = coder.decodeObject(forKey: "sign_all_num") as? Int
        signNum = coder.decodeObject(forKey: "sign_num") as? Int
        singleNum = coder.decodeObject(forKey: "single_num") as? Int
        status = coder.decodeObject(forKey: "status") as? String
        timerCashTime = coder.decodeObject(forKey: "timer_cash_time") as? Int
        token = coder.decodeObject(forKey: "token") as? String
    }
    
    
}

class SignListModel: Mapable {
    
    var day : Int!
    var gold : Int!
    var isActive : Int!
    var text : String!
    var cash: Int!
    var isToday : Int!
    var isWithdraw: Bool!
    
    required init(json: JSON) {
        day = json["day"].intValue
        gold = json["gold"].intValue
        text = json["text"].stringValue
        isActive = json["is_active"].intValue
        isToday = json["is_today"].intValue
        cash = json["cash"].intValue
        isWithdraw = json["isWithdraw"].boolValue
    }
}

class SignActiveModel: Mapable {
    
    var gold : Int!
    var cash : Int!
    var doubleNum : Int!
    
    required init(json: JSON) {
        gold = json["gold"].intValue
        cash = json["cash"].intValue
        doubleNum = json["double_num"].intValue
    }
}

class GoldListModel: Mapable {
    
    var level : Int!
    var gold : Int!
    /// 类型，1-未完成，2-已完成未领取，3-已领取
    var type : Int!
    
    required init(json: JSON) {
        level = json["level"].intValue
        gold = json["gold"].intValue
        type = json["type"].intValue
    }
}

class GoldActiveModel: Mapable {
    
    var gold : Int!
    
    required init(json: JSON) {
        gold = json["gold"].intValue
    }
}



