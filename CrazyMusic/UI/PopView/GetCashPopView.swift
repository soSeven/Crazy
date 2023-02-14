//
//  GetCashPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GetCashPopView: UIView {
    
    init(cash: Int) {
        
        let bgImg = UIImage.create("correct_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .bold, size: 18.uiX)
        titleLbl.text = "恭喜！提现申请成功！"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 18.uiX
        titleLbl.y = 46.5.uiX
        addSubview(titleLbl)
        
        let closeImg = UIImage.create("choose_icon_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 15.5.uiX
        closeBtn.x = width - closeBtn.width - 19.uiX
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(closeBtn)
        
        let u = UserManager.shared.login.value.0
        
        let redHeartView = UIImageView()
        redHeartView.kf.setImage(with: URL(string: u?.avatar ?? ""))
        redHeartView.width = 44.uiX
        redHeartView.height = 44.uiX
        redHeartView.y = 98.5.uiX
        redHeartView.x = 83.uiX
        redHeartView.cornerRadius = 22.uiX
        redHeartView.borderColor = .init(hex: "#EF8BFF")
        redHeartView.borderWidth = 1.uiX
        addSubview(redHeartView)
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#EADADA")
        textLbl.font = .init(style: .regular, size: 15.uiX)
        textLbl.text = u?.nickname
        textLbl.textAlignment = .left
        textLbl.width = 150.uiX
        textLbl.height = 14.5.uiX
        textLbl.y = 113.5.uiX
        textLbl.x = redHeartView.frame.maxX + 12.uiX
        addSubview(textLbl)
        
        let textLbl2 = UILabel()
        textLbl2.textColor = .init(hex: "#F4CE39")
        textLbl2.font = .init(style: .regular, size: 13.uiX)
        textLbl2.text = "可在【微信】→【我的零钱】中查看"
        textLbl2.textAlignment = .center
        textLbl2.width = width
        textLbl2.height = 12.5.uiX
        textLbl2.y = 243.uiX
        textLbl2.x = 0
        addSubview(textLbl2)
        
        let cashLbl = UILabel()
        cashLbl.textAlignment = .center
        cashLbl.attributedText = getCashStr(num: cash)
        cashLbl.width = width
        cashLbl.height = 23.5.uiX
        cashLbl.y = 166.5.uiX
        cashLbl.x = 0
        addSubview(cashLbl)
        
        let btnImg = UIImage.create("withdraw_img_success_btn")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 270.5.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
    }
    
    private func getCashStr(num: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .bold, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 33.uiX)!,
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let s = NSMutableAttributedString(string: "元", attributes: a1)
        let s2 = NSMutableAttributedString(string: String(format: "%.2f", Float(num)/10000), attributes: a2)
        s2.append(s)
        return s2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
