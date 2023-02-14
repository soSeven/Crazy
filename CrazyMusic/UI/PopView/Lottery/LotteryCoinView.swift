//
//  LotteryCoinView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LotteryCoinView: UIView {
    
    var action: (()->())?
    
    init(coin: Int) {
        
        YBPlayAudio.success()
        
        let bgImg = UIImage.create("reward_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 0
        addSubview(bgImgView)
        
        let redHeartImg = UIImage.create("qtx-cj-jbjl-jb")
        let redHeartView = UIImageView(image: redHeartImg)
        redHeartView.size = redHeartImg.snpSize
        redHeartView.y = 61.5.uiX
        redHeartView.x = (width - redHeartView.width)/2.0
        
        let lightImg = UIImage.create("ggjl-gx")
        let lightView = UIImageView(image: lightImg)
        lightView.size = lightImg.snpSize
        lightView.center = redHeartView.center
        
        addSubview(lightView)
        addSubview(redHeartView)
        
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        lightView.layer.add(ro, forKey: "rotationAnimation")
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#FFE03A")
        textLbl.font = .init(style: .medium, size: 21.uiX)
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 20.uiX
        textLbl.y = 186.5.uiX
        textLbl.attributedText = getCurrentAttributedText(n: coin)
        addSubview(textLbl)
        
        let lbl1 = UILabel()
        lbl1.textColor = .init(hex: "#E1DAE6")
        lbl1.font = .init(style: .regular, size: 14.uiX)
        lbl1.y = 230.5.uiX
        lbl1.x = 0
        lbl1.height = 14.uiX
        lbl1.width = width
        lbl1.attributedText = getAttributedText(n: UserManager.shared.user?.gold ?? 0)
        lbl1.textAlignment = .center
        addSubview(lbl1)
        
        let btnImg = UIImage.create("an-jxcg")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 267.5.uiX
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            MobClick.event("award_prize_continue")
            self.action?()
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
    private func getCurrentAttributedText(n: Int) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 21.uiX),
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        
        let a1 = NSMutableAttributedString(string: "\(n)", attributes: att1)
        let a2 = NSAttributedString(string: "个", attributes: att2)
        a1.append(a2)
        return a1
    }
    
    private func getAttributedText(n: Int) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#E1DAE5")
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        
        let a1 = NSMutableAttributedString(string: "金币余额", attributes: att1)
        let a2 = NSAttributedString(string: "\(n)", attributes: att2)
        let a3 = NSAttributedString(string: "个", attributes: att1)
        a1.append(a2)
        a1.append(a3)
        return a1
    }
    
}
