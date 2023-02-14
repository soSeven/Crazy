//
//  CashModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/13.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetCashModel: Mapable {
    
    var type : Int!
    var msg : String!

    required init(json: JSON) {
        type = json["type"].intValue
        msg = json["msg"].stringValue
    }
    
}
