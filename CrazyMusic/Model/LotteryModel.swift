//
//  LotteryModel.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/17.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class LotteryListModel: Mapable {
    
    var time: Int!
    var items: [Int]!
    
    required init(json: JSON) {
        time = json["expiration_time"].intValue
        items = json["item"].arrayValue.map{ $0.intValue }
    }
    
    init() {
        time = 15
        items = [100000, 300000, 500000, 1000000]
    }
    
}

class LotteryModel: Mapable {
    
    var type: Int!
    var num: Int!
    
    required init(json: JSON) {
        type = json["type"].intValue
        num = json["num"].intValue
    }
    
    init() {
        type = 3
        num = 100000
    }
    
}
