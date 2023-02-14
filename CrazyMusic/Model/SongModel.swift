//
//  SongModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import SwiftyJSON

class SongModel: Mapable {
    
    /// 歌曲ID
    var id : Int!
    /// 歌曲关数
    var level : Int!
    /// 歌曲名称，第一手为正确歌曲
    var content : [String]!
    /// 歌曲
    var url : String!
    /// 完成此关是否需要看广告
    var isAd: Bool!
    /// 完成此关后还需要完成多少关可提现
    var withdrawLevel: Int!
    /// 完成此关后总共需要多少关提现
    var withdrawLevelAll: Int!
    /// 完成此关后还需要完成多少关可提现-实际值
    var withdrawLevelReal: Int!
    /// 完成此关后总共需要多少关提现-实际值
    var withdrawLevelAllReal: Int!
    /// 完成此关后是否可提现
    var isWithdraw: Bool!
    /// 完成此关获得的单倍红包数量
    var cash: Int!
    /// 完成此关获得的看广告红包数量
    var cashAd: Int!
    
    required init(json: JSON) {
        id = json["id"].intValue
        level = json["level"].intValue
        content = json["content"].arrayValue.map{ $0.stringValue }
        url = json["url"].stringValue
        isAd = json["is_adv"].boolValue
        withdrawLevel = json["withdraw_level"].intValue
        withdrawLevelAll = json["withdraw_level_all"].intValue
        withdrawLevelReal = json["withdraw_level_real"].intValue
        withdrawLevelAllReal = json["withdraw_level_all_real"].intValue
        isWithdraw = json["is_withdraw"].boolValue
        cash = json["cash"].intValue
        cashAd = json["cash_ad"].intValue
    }
}

class AnswerRightModel: Mapable {
    
    var gold: Int
    var goldToCashNum: Int
    var song: SongModel!
    
    required init(json: JSON) {
        gold = json["gold"].intValue
        goldToCashNum = json["gold_to_cash_num"].intValue
        song = SongModel(json: json["song"])
    }
    
}

class AnswerErrorModel: Mapable {
    
    var hp: Int
    
    required init(json: JSON) {
        hp = json["hp"].intValue
    }
    
}

class AnswerDeleteModel: Mapable {
    
    var singleNum: Int
    
    required init(json: JSON) {
        singleNum = json["single_num"].intValue
    }
    
}

class RedBagModel: Mapable {
    
    var cash: Int
    
    required init(json: JSON) {
        cash = json["cash"].intValue
    }
    
}

