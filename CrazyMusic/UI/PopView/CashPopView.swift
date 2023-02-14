//
//  CashPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Lottie

enum CashPopViewType: Int {
    case play
    case cash
    case sign
}

class CashPopView: UIView {
    
    let cashLbl = UILabel()
    let btn = MusicButton()
    let titleLbl1 = UILabel()
    
    init(num: Float, type: CashPopViewType) {
        
        YBPlayAudio.award()
        
        let bgImg = UIImage.create("img_package_all")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 260.uiX)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.x = 0
        bgImgView.y = 0
        bgImgView.size = bgImg.snpSize
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#B07229")
        titleLbl.font = .init(style: .medium, size: 20.uiX)
        titleLbl.text = "恭喜你获得"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 19.5.uiX
        titleLbl.y = 19.5.uiX
        addSubview(titleLbl)
        
        titleLbl1.textColor = .init(hex: "#BF8E54")
        titleLbl1.font = .init(style: .regular, size: 12.uiX)
        titleLbl1.text = "已放入你的红包账户"
        titleLbl1.textAlignment = .center
        titleLbl1.width = width
        titleLbl1.height = 11.5.uiX
        titleLbl1.y = 46.5.uiX
        addSubview(titleLbl1)
        
        cashLbl.attributedText = getCashStr(num: num)
        cashLbl.textAlignment = .center
        cashLbl.width = width
        cashLbl.height = 35.uiX
        cashLbl.y = 79.uiX
        addSubview(cashLbl)
        
        let titleLbl2 = UILabel()
        titleLbl2.textColor = .init(hex: "#F25543")
        titleLbl2.font = .init(style: .regular, size: 12.uiX)
        let cash = Float(UserManager.shared.login.value.0?.cash ?? 0) / 10000
        titleLbl2.text = String(format: "当前余额%.2f元", cash)
        titleLbl2.textAlignment = .center
        titleLbl2.width = width
        titleLbl2.height = 11.5.uiX
        titleLbl2.y = 117.5.uiX
        addSubview(titleLbl2)
        
        let closeImg = UIImage.create("countdown_img_bgd")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.width = 23.5.uiX
        closeBtn.height = 23.5.uiX
        closeBtn.y = bgImgView.frame.maxY + 3.uiX
        closeBtn.x = (width - closeBtn.width)/2.0
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        closeBtn.isUserInteractionEnabled = false
        addSubview(closeBtn)
        
        var imgName: String
        switch type {
        case .play:
            imgName = "diamond_package_img_btn"
            btn.isUserInteractionEnabled = false
        case .cash:
            imgName = "hb-cghb-ljtx-an"
            btn.isUserInteractionEnabled = true
        case .sign:
            imgName = "hb-cghb-ckdk-an"
            btn.isUserInteractionEnabled = true
        }
        let btnImg = UIImage.create(imgName)
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 164.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        let ro = CABasicAnimation(keyPath: "transform.scale")
        ro.fromValue = 0.9
        ro.toValue = 1
        ro.duration = 0.5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.autoreverses = true
        ro.fillMode = .forwards
        btn.layer.add(ro, forKey: "rotationAnimation")
        
        let adView = ListAdAnimationView(slotId: nil, w: width)
        adView.x = 0
        adView.y = closeBtn.frame.maxY + 3.uiX
        addSubview(adView)
        
        var countDown = 3
        closeBtn.setTitle("\(countDown)", for: .normal)
        closeBtn.titleLabel?.font = .init(style: .regular, size: 15.uiX)
        closeBtn.setTitleColor(.init(hex: "#E2A2EC"), for: .normal)
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            countDown -= 1
            if countDown <= 0 {
                closeBtn.isUserInteractionEnabled = true
                closeBtn.setTitle(nil, for: .normal)
                closeBtn.setImage(.create("countdown_img_close"), for: .normal)
                self.btn.isUserInteractionEnabled = true
            } else {
                closeBtn.setTitle("\(countDown)", for: .normal)
            }
        }).disposed(by: rx.disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getCashStr(num: Float) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#F25543")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 38.uiX)!,
            .foregroundColor: UIColor(hex: "#F25543")
        ]
        let s = NSMutableAttributedString(string: String(format: "%.2f", num), attributes: a2)
        let s2 = NSAttributedString(string: "元", attributes: a1)
        s.append(s2)
        return s
    }
    
}
