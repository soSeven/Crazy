//
//  DiamondRedBagModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class DiamondRedBagModel: Mapable {
    
    var cash : Int!
    var level : Int!

    required init(json: JSON) {
        cash = json["cash"].intValue
        level = json["level"].intValue
    }
    
}
