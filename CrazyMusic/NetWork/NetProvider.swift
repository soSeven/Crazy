//
//  NetProvider.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Moya
import FCUUID
import Alamofire
import FileKit
import Kingfisher
import SwifterSwift
import AdSupport

let NetProvider = MoyaProvider<NetAPI>(requestClosure: { (endpoint, done) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 20//设置请求超时时间
        done(.success(request))
    } catch {

    }
})

public enum CheckCodeEvent: String {
    case check = "check" //验证手机号
    case bind = "bind" //绑定手机号
    case regLogin = "reg_login" //使用手机号+验证码的方式进行注册或登录
}

//nickname=昵称,area=地区,sex=性别,constellation=星座,avatar=头像
public enum UserInfoChangeType: String {
    
    case nickname = "nickname"
    case area = "area"
    case sex = "sex"
    case constellation = "constellation"
    case avatar = "avatar"

}

//修改的字段名,avatar=群头像,name=群名称,join_auth=加群权限.1=群主验证通过,2=无需验证,3=拒绝所有人
public enum CircleInfoChangeType: String {
    
    case avatar = "avatar"
    case name = "name"
    case auth = "join_auth"

}

public enum ThirdLoginType: String {
    
    case weChat = "wechat"
    case apple = "apple_id"

}

public enum LocationAuthType: String {
    
    case open = "open"
    case close = "close"

}

public enum NetAPI {
    
    /// 用户登录
    case login
    /// 系统配置
    case configure(token: String? = nil, userId: String? = nil)
    /// 用户信息
    case updateUser(token: String? = nil, userId: String? = nil)
    /// 注销登录
    case loginOut
    /// 绑定微信号
    case bindWeChat(openid: String, sex: Int, unionid: String, avatar: String, nickName: String)
    /// 领取定时红包
    case redBagByTime
    /// 每日签到
    case signSingle
    /// 每日签到-翻倍
    case signDouble
    /// 签到领取红包
    case signRedBag(day: Int)
    /// 金币拆红包
    case diamondCashRedBag
    /// 转盘  1-闯关转盘，2-签到转盘
    case lotteryList(type: Int)
    /// 抽奖
    case lottery
    /// 答对获取红包
    case answerRight(cash: Int, level: Int, songId: Int, isDouble: Bool)
    /// 答错消耗生命值
    case answerWrong(songId: Int)
    /// 领取看广告生命值
    case addLife
    /// 选择音乐类型
    case changeMusic(id: Int)
    /// 看广告领取排错
    case getDeleteAnswer
    /// 使用排错
    case useDeleteAnswer
    /// 友盟device_token上报
    case updateDeviceToken(token: String)
    /// 反馈
    case help(content: String, phone: String)
    /// 提现
    case getCash(cash: Int)
    /// 提现记录列表
    case cashRecordList(page: Int, limit: Int)
    /// 瓜分金币
    case goldTask(level: Int)
    
}

extension NetAPI: TargetType {
    
    static var getBaseURL: String {
        if AppDefine.isDebug {
            return "https://api-testing.dengaw.cn/"
        } else {
            return "https://api.dengaw.cn/"
        }
        
    }
    
    static func getHtmlProtocol(type: Int) -> URL? {
        return URL(string: String(format: "%@api/agreement/detail?id=%d", NetAPI.getBaseURL, type))
    }
    
    public var baseURL: URL {
        let baseUrl = URL(string: NetAPI.getBaseURL)!
        return baseUrl
    }
    
    public var path: String {
        switch self {
        case .login:
            return "api/v100/login"
        case .updateUser:
            return "api/v100/user/detail"
        case .diamondCashRedBag:
            return "api/v100/user/convert"
        case .cashRecordList:
            return "api/v100/order/list"
        case .getCash:
            return "api/v100/order/withdrawal"
        case .configure:
            return "api/v100/config"
        case .changeMusic:
            return "api/v100/user/music/type"
        case .signSingle:
            return "api/v100/user/active"
        case .signDouble:
            return "api/v100/user/active/double"
        case .signRedBag:
            return "api/v100/user/active/cash"
        case .answerRight:
            return "api/v100/song"
        case .answerWrong:
            return "api/v100/song/hp"
        case .getDeleteAnswer:
            return "api/v100/user/adv/single"
        case .useDeleteAnswer:
            return "api/v100/user/use/single"
        case .addLife:
            return "api/v100/user/adv/hp"
        case .redBagByTime:
            return "api/v100/user/timer/cash"
        case .bindWeChat:
            return "api/v100/user/bind"
        case .loginOut:
            return "api/v100/logout"
        case .help:
            return "api/v100/feedback"
        case .updateDeviceToken:
            return "api/v100/user/device_token"
        case .lottery:
            return "api/v100/user/draw"
        case .lotteryList:
            return "api/v100/user/turntable"
        case .goldTask:
            return "api/v100/user/gold/task"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .updateUser:
            return .get
        case .cashRecordList:
            return .get
        case .configure:
            return .get
        default:
            break
        }
        return .post
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        
        var params:[String:Any] = [:]
        params["timestamp"] = Date().timeIntervalSince1970.string
        if let id = UserManager.shared.login.value.0?.id {
            params["userid"] = id
        }
        if let token = UserManager.shared.login.value.0?.token {
            params["token"] = token
        }
        
        switch self {
        case .login:
            params["device_number"] = UIDevice.current.uuid()
            params["os"] = 1
            params["idfa"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        case let .updateUser(token, userId):
            if let t = token {
                params["token"] = t
            }
            if let u = userId {
                params["userid"] = u
            }
        case let .configure(token, userId):
            if let t = token {
                params["token"] = t
            }
            if let u = userId {
                params["userid"] = u
            }
        case let .cashRecordList(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .getCash(cash):
            params["cash"] = cash
        case let .changeMusic(id):
            params["id"] = id
        case let .answerRight(cash, level, songId, isDouble):
            params["cash"] = cash
            params["level"] = level
            params["song_id"] = songId
            params["is_double"] = isDouble ? 1 : 0
        case let .answerWrong(songId):
            params["song_id"] = songId
        case let .bindWeChat(openid, sex, unionid, avatar, nickName):
            params["openid"] = openid
            params["sex"] = sex
            params["unionid"] = unionid
            params["avatar"] = avatar
            params["nickname"] = nickName
        case let .help(content, phone):
            params["content"] = content
            params["contact"] = phone
        case let .updateDeviceToken(token):
            params["device_token"] = token
        case let .signRedBag(day):
            params["day"] = day
        case let .lotteryList(type):
            params["type"] = type
        case let .goldTask(level):
            params["level"] = level
        default:
            break
        }
        params["sign"] = getSign(pa: params)
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        var headers:[String : String] = [:]
        headers["device-number"] = UIDevice.current.uuid()
        headers["client-type"] = "1"
        headers["channel"] = "App Store"
        headers["version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        headers["idfa"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        headers["userid"] = UserManager.shared.login.value.0?.id ?? ""
        headers["token"] = UserManager.shared.login.value.0?.token ?? ""
        
        switch self {
        case let .updateUser(token, userId):
            if let t = token {
                headers["token"] = t
            }
            if let u = userId {
                headers["userid"] = u
            }
        case let .configure(token, userId):
            if let t = token {
                headers["token"] = t
            }
            if let u = userId {
                headers["userid"] = u
            }
        default:
            break
        }
        return headers
    }
    
    private func getSign(pa: [String:Any]) -> String {
        let secretKey = AppDefine.isDebug ? "fengkuangcaige" : "72JbtAMsgz7xXLf29c6i6l8wDFlqJ7py"
        let a = pa.sorted { (v1, v2) -> Bool in
            v1.key < v2.key
        }
        let s = a.map { (key, value) -> String in
            "\(key)=\(value)"
        }.joined(separator: "&") + "&key=\(secretKey)"
        
        let md5 = s.md5.uppercased()
        return md5
    }
    
}

