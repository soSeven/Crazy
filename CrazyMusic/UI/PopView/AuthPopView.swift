//
//  AuthPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/20.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import YYText

class AuthPopView: UIView {
    
    init(action: @escaping ()->()) {
        
        let bgImg = UIImage.create("install_bg2")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .bold, size: 18.uiX)
        titleLbl.text = "用户隐私保护指引"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 18.uiX
        titleLbl.y = 39.uiX
        addSubview(titleLbl)
        
        let text = NSMutableAttributedString(string: "欢迎进入疯狂猜歌！我们非常重视您的个人信息和隐私保护。为了更好地保障您的个人权益，在您使用我们的产品前，请认真阅读")
        text.yy_font = .init(style: .regular, size: 13.uiX)
        text.yy_color = .init(hex: "#ffffff")
        let a = NSMutableAttributedString(string: "《用户服务协议》")
        a.yy_font = .init(style: .regular, size: 13.uiX)
        a.yy_color = .init(hex: "#FFF15B")
        let hi = YYTextHighlight()
        hi.tapAction =  {[weak self] containerView, text, range, rect in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView, let nav = sup.navigationController {
                let u = UserManager.shared.configure?.page
                let web = WebViewController()
                web.url = URL(string: u?.userAgreement)
                nav.pushViewController(web)
            }
        }
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        text.append(a)
        let b = NSMutableAttributedString(string: "与")
        b.yy_font = .init(style: .regular, size: 13.uiX)
        b.yy_color = .init(hex: "#ffffff")
        text.append(b)
        let d = NSMutableAttributedString(string: "《隐私政策》")
        d.yy_font = .init(style: .regular, size: 13.uiX)
        d.yy_color = .init(hex: "#FFF15B")
        let hid = YYTextHighlight()
        hid.tapAction =  {[weak self] containerView, text, range, rect in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView, let nav = sup.navigationController {
                let u = UserManager.shared.configure?.page
                let web = WebViewController()
                web.url = URL(string: u?.privacyPolicy)
                nav.pushViewController(web)
            }
        }
        d.yy_setTextHighlight(hid, range: d.yy_rangeOfAll())
        text.append(d)
        let e = NSMutableAttributedString(string: "的全部内容，点击同意并接受全部条款后开始使用我们的产品和服务。")
        e.yy_font = .init(style: .regular, size: 13.uiX)
        e.yy_color = .init(hex: "#ffffff")
        text.append(e)
        
        let textLbl1 = YYLabel()
        textLbl1.font = .init(style: .regular, size: 13.uiX)
        textLbl1.textColor = .init(hex: "#FFFFFF")
        textLbl1.attributedText = text
        textLbl1.frame = CGRect(x: 26.uiX, y: 80.5.uiX, width: 259.uiX, height: 112.5.uiX)
        textLbl1.numberOfLines = 0
        addSubview(textLbl1)
        
        let img = UIImage.create("sexx_icon")
        let markImgView = UIImageView(image: img)
        markImgView.size = img.snpSize
        markImgView.x = 26.uiX
        markImgView.y = 222.5.uiX
        addSubview(markImgView)
        
        let tLbl1 = UILabel()
        tLbl1.text = "存储空间、设备信息"
        tLbl1.textColor = .init(hex: "#FFFFFF")
        tLbl1.font = .init(style: .medium, size: 15.uiX)
        tLbl1.x = markImgView.frame.maxX + 12.uiX
        tLbl1.y = 228.5.uiX
        tLbl1.width = 200.uiX
        tLbl1.height = 14.5.uiX
        addSubview(tLbl1)
        
        let tLbl2 = UILabel()
        tLbl2.textColor = .init(hex: "#FFFFFF")
        tLbl2.text = "必要权限，用于缓存相关文件"
        tLbl2.font = .init(style: .regular, size: 13.uiX)
        tLbl2.x = markImgView.frame.maxX + 12.uiX
        tLbl2.y = 250.5.uiX
        tLbl2.width = 200.uiX
        tLbl2.height = 13.uiX
        addSubview(tLbl2)
        
        let btnImg = UIImage.create("ty")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 297.5.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: { _ in
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            action()
            MobClick.event("Main_PermissionsGranted")
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        let nextbtn = MusicButton()
        nextbtn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
        nextbtn.setTitle("不同意并退出", for: .normal)
        nextbtn.setTitleColor(.init(hex: "#C662D5"), for: .normal)
        nextbtn.width = 90.uiX
        nextbtn.y = 7.uiX + btn.frame.maxY
        nextbtn.x = (width - nextbtn.width)/2.0
        nextbtn.rx.tap.subscribe(onNext: {_ in
            MobClick.event("Main_PermissionsDenied")
            exit(0)
        }).disposed(by: rx.disposeBag)
        addSubview(nextbtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
