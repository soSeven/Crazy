//
//  GetCashLevelView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GetCashLevelView: UIView {
    
    init(num: Int) {
        
        let bgImg = UIImage.create("cashAlertBg")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .medium, size: 18.uiX)
        titleLbl.text = "提现失败"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 18.uiX
        titleLbl.y = 43.5.uiX
        addSubview(titleLbl)
        
        let textLbl = UILabel()
        textLbl.attributedText = getLevelStr(num: num)
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 14.uiX
        textLbl.y = 93.5.uiX
        addSubview(textLbl)
        
        let btnImg = UIImage.create("an-wzdl")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 155.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getLevelStr(num: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#DAD1DE")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        let s = NSMutableAttributedString(string: "抱歉，需要通过", attributes: a1)
        let s2 = NSMutableAttributedString(string: " \(num)关 ", attributes: a2)
        let s3 = NSMutableAttributedString(string: "才可提现", attributes: a1)
        s.append(s2)
        s.append(s3)
        return s
    }
    
}
