//
//  LotteryCashView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import RxCocoa
import RxSwift

class LotteryCashView: UIView {
    
    var action: (()->())?
    
    init(cash: Int) {
        
        YBPlayAudio.success()
        
        let bgImg = UIImage.create("reward_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 0
        addSubview(bgImgView)
        
        let redHeartImg = UIImage.create("ggjl-hb-icon")
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
        textLbl.y = 205.uiX
        textLbl.text = "+\(cash.cashDigits)元"
        addSubview(textLbl)
        
        let btnImg = UIImage.create("an-jxcg")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 268.uiX
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            self.action?()
            MobClick.event("award_prize_continue")
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
}
