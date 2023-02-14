//
//  CashAlert2PopView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/8.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CashAlert2PopView: UIView {
    
    init(action: @escaping ()->()) {
        
        let bgImg = UIImage.create("cashAlertBg")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .bold, size: 18.uiX)
        titleLbl.text = "温馨提示"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 18.uiX
        titleLbl.y = 43.5.uiX
        addSubview(titleLbl)
        
        let closeImg = UIImage.create("tx-wxts-qx")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 155.uiX
        closeBtn.x = 23.uiX
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(closeBtn)
        
        let textLbl = UILabel()
        textLbl.text = "提现成功后，连续打卡天数将会重置，您可以\n选择继续打卡或直接提现"
        textLbl.textColor = .init(hex: "#FFFFFF")
        textLbl.font = .init(style: .regular, size: 13.uiX)
        textLbl.numberOfLines = 0
        textLbl.width = 260.uiX
        textLbl.x = 26.uiX
        textLbl.height = 40.uiX
        textLbl.y = 84.uiX
        addSubview(textLbl)
        
        let btnImg = UIImage.create("tx-wxts-tx")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 155.uiX
        btn.x = 153.5.uiX
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            action()
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
