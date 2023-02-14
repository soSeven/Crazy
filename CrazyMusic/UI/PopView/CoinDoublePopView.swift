//
//  CoinDoublePopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import Lottie

class CoinDoublePopView: UIView {
    
    var action: ((Bool)->())?
    
    init() {
        
        YBPlayAudio.success()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            YBPlayAudio.diamond()
        }
        
        let bgImg = UIImage.create("reward_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 30.uiX)
        super.init(frame: frame)
        
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 0
        addSubview(bgImgView)
        
        let redHeartImg = UIImage.create("reward_img_light")
        let redHeartView = UIImageView(image: redHeartImg)
        redHeartView.size = redHeartImg.snpSize
        redHeartView.y = 35.5.uiX
        redHeartView.x = (width - redHeartView.width)/2.0
        addSubview(redHeartView)
        
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        redHeartView.layer.add(ro, forKey: "rotationAnimation")
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#FFFFFF")
        textLbl.font = .init(style: .medium, size: 18.uiX)
        textLbl.text = "+\((UserManager.shared.configure?.const.guessSongMasonry ?? 0) * 2)"
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 12.5.uiX
        textLbl.y = 211.5.uiX
        addSubview(textLbl)
        
        let btnImg = UIImage.create("reward_img_btn_1")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 261.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            self.action?(true)
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        let animation = Animation.named("data", subdirectory: "9")
        let animationView = AnimationView(animation: animation)
        animationView.contentMode = .scaleAspectFill
        animationView.y = -70.uiX
        animationView.width = 82.uiX
        animationView.height = 250.uiX
        animationView.x = (width - animationView.width)/2.0
        animationView.backgroundBehavior = .pauseAndRestore
        addSubview(animationView)
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
