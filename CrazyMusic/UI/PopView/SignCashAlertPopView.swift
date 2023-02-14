//
//  SignCashAlertPopView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/8.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignCashAlertPopView: UIView {
    
    init(num: Int, num2: Int) {
        
        let bgImg = UIImage.create("cashAlertBg")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .bold, size: 18.uiX)
        titleLbl.text = "每日打卡任务"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 18.uiX
        titleLbl.y = 43.5.uiX
        addSubview(titleLbl)
        
        let textLbl = UILabel()
        textLbl.numberOfLines = 0
        textLbl.attributedText = getLevelStr(num: num, num2: num2)
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 50.uiX
        textLbl.y = 85.uiX
        addSubview(textLbl)
        
        let btnImg = UIImage.create("xsyd-mrdkrw-hd-an")
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
    
    private func getLevelStr(num: Int, num2: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#DAD1DD")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        let s = NSMutableAttributedString(string: "今日已收集", attributes: a1)
        let s2 = NSMutableAttributedString(string: " \(num)", attributes: a2)
        let s3 = NSMutableAttributedString(string: "个闯关红包，再收集", attributes: a1)
        let s4 = NSMutableAttributedString(string: " \(num2)", attributes: a2)
        let s5 = NSMutableAttributedString(string: "个\n即可打卡成功！为了提现——冲鸭！", attributes: a1)
        s.append(s2)
        s.append(s3)
        s.append(s4)
        s.append(s5)
        return s
    }
    
}
