//
//  LoginOutPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import YYText

class LoginOutPopView: UIView {
    
    let viewModel = LoginOutViewModel()
    
    init(action: @escaping ()->()) {
        
        let bgImg = UIImage.create("install_bg")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .bold, size: 18.uiX)
        titleLbl.text = "账号注销"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 18.uiX
        titleLbl.y = 39.uiX
        addSubview(titleLbl)
        
        let textLbl1 = UILabel()
        textLbl1.font = .init(style: .regular, size: 13.uiX)
        textLbl1.textColor = .init(hex: "#FFFFFF")
        textLbl1.text =  "如您注销疯狂猜歌帐号，您将无法再以此帐号登录和使用疯狂猜歌的产品与服务。您注销帐号后，帐号内的所有数据信息（包括您所获取的钻石、红包等）将无法恢复，请您注销前慎重考虑如您经过慎重考虑后仍确定注销疯狂猜歌帐号，请您仔细阅读并充分理解《疯狂猜歌用户帐号注销协议》的内容，并请特别关注本协议中加粗形式的条款内容。在同意全部内容且在帐号符合全部注销条件后，请您按照注销操作指引进行操作。"
        textLbl1.frame = CGRect(x: 26.uiX, y: 80.5.uiX, width: 259.uiX, height: 192.5.uiX)
        textLbl1.numberOfLines = 0
        addSubview(textLbl1)
        
        let textLbl2 = UILabel()
        textLbl2.font = .init(style: .regular, size: 13.uiX)
        textLbl2.textColor = .init(hex: "#FFFFFF")
        textLbl2.text =  "在您勾选本注销协议并点击【确定】操作后，视为您已经同意并签署和遵守本协议全部内容，本协议即具备相应的法律效力。 "
        textLbl2.frame = CGRect(x: 26.uiX, y: 296.5.uiX, width: 259.uiX, height: 60.uiX)
        textLbl2.numberOfLines = 0
        addSubview(textLbl2)
        
        let closeImg = UIImage.create("qx")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 405.5.uiX
        closeBtn.x = 161.5.uiX
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(closeBtn)
        
        let pub = PublishRelay<Void>()
        
        let pBtn = MusicButton()
        addSubview(pBtn)
        pBtn.width = 15.uiX
        pBtn.height = 15.uiX
        pBtn.x = 37.5.uiX
        pBtn.y = 383.uiX
        pBtn.setImage(.create("withdraw_icon_choose_nor"), for: .normal)
        pBtn.setImage(.create("withdraw_icon_choose"), for: .selected)
        pBtn.isSelected = true
        pBtn.rx.tap.subscribe(onNext: {[weak pBtn] _ in
            guard let pBtn = pBtn else { return }
            pBtn.isSelected = !pBtn.isSelected
        }).disposed(by: rx.disposeBag)
        
        let btnImg = UIImage.create("zx")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 405.5.uiX
        btn.x = 24.5.uiX
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if !pBtn.isSelected {
                Observable.just("请先同意协议").bind(to: self.rx.toastText()).disposed(by: self.rx.disposeBag)
                return
            }
            pub.accept(())
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        let text = NSMutableAttributedString(string: "已阅读并同意")
        text.yy_font = .init(style: .regular, size: 14.uiX)
        text.yy_color = .init(hex: "#ffffff")
        let a = NSMutableAttributedString(string: "《用户账号注销协议》")
        a.yy_font = .init(style: .regular, size: 14.uiX)
        a.yy_color = .init(hex: "#277DFF")
        let hi = YYTextHighlight()
        hi.tapAction =  {[weak self] containerView, text, range, rect in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            action()
        }
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        text.append(a)
        let protocolLbl = YYLabel()
        protocolLbl.x = pBtn.frame.maxX + 5.uiX
        protocolLbl.y = 383.5.uiX
        protocolLbl.height = 13.5.uiX
        protocolLbl.width = 230.uiX
        protocolLbl.attributedText = text;
        addSubview(protocolLbl)
       
        let input = LoginOutViewModel.Input(request: pub.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: {[weak self] s in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            if let view = UIApplication.shared.keyWindow {
                Observable.just(s).bind(to: view.rx.toastText()).disposed(by: self.rx.disposeBag)
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
