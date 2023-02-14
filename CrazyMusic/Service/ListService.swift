//
//  ListService.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ListService {
    
    func requestList<T: PageModelType>(page: Int, limit: Int) -> Observable<T?>
    
}

class CashReocrdListService: ListService {
    
    func requestList<T>(page: Int, limit: Int) -> Observable<T?> where T : PageModelType {
        return NetManager.requestObj(.cashRecordList(page: page, limit: limit), type: T.self).asObservable()
    }
    
}
