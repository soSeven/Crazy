//
//  NewUserPlayCashView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/16.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit

class NewUserPlayCashView: UIView {
    
    var action: (()->())?
    var closeAction: (()->())?
    
    init() {
        
        YBPlayAudio.success()
        
        let bgImg = UIImage.create("xsfl-jl-bg")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 0
        addSubview(bgImgView)
        
        let redHeartImg = UIImage.create("xsfl-jltc-gxn-icon")
        let redHeartView = UIImageView(image: redHeartImg)
        redHeartView.size = redHeartImg.snpSize
        redHeartView.y = -35.uiX
        redHeartView.x = (width - redHeartView.width)/2.0
        addSubview(redHeartView)
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#FFFFFF")
        textLbl.font = .init(style: .medium, size: 18.uiX)
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 17.uiX
        textLbl.y = 72.5.uiX
        textLbl.text = "获得新手提现机会"
        addSubview(textLbl)
        
        let lbl1 = UILabel()
        lbl1.textColor = .init(hex: "#E1DAE6")
        lbl1.font = .init(style: .regular, size: 14.uiX)
        lbl1.y = 119.5.uiX
        lbl1.x = 0
        lbl1.height = 14.uiX
        lbl1.width = width
        lbl1.attributedText = getAttributedText(n: UserManager.shared.user?.cash ?? 0)
        lbl1.textAlignment = .center
        addSubview(lbl1)
        
        let closeImg = UIImage.create("choose_icon_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 19.uiX
        closeBtn.x = width - closeBtn.width - 19.uiX
        addSubview(closeBtn)
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            self.closeAction?()
        }).disposed(by: rx.disposeBag)
        
        let btnImg = UIImage.create("xsfl-ljtx-an")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 187.uiX
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            self.action?()
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
    private func getAttributedText(n: Int) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        
        let a1 = NSMutableAttributedString(string: "当前账户余额：", attributes: att1)
        let a2 = NSAttributedString(string: "\(n.cashDigits)", attributes: att2)
        let a3 = NSAttributedString(string: "元", attributes: att1)
        a1.append(a2)
        a1.append(a3)
        return a1
    }
    
}
