//
//  CoinPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/10.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import Lottie

class CoinPopView: UIView {
    
    var action: ((Bool)->())?
    private let rewardAd: RewardVideoAd
    
    init(model: SongCellViewModel) {
        
        YBPlayAudio.success()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            YBPlayAudio.diamond()
        }
        
        rewardAd = RewardVideoAd(slotId: "945408896", gdSlotId: "7031529825951801")
        
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
        textLbl.text = "+\(UserManager.shared.configure?.const.guessSongMasonry ?? 0)"
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 12.5.uiX
        textLbl.y = 211.5.uiX
        addSubview(textLbl)
        
        let btnImg = UIImage.create(model.level > AppDefine.minDoubleRewardLevel ? "reward_img_btn" : "reward_img_btn_1")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 261.uiX
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        rewardAd.completion = {[weak self] in
            guard let self = self else { return }
            let d = CoinDoublePopView()
            d.action = self.action
            PopView.show(view: d)
        }
        
        if model.level > AppDefine.minDoubleRewardLevel {
            
            btn.rx.tap.subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                if let sup = self.parentViewController {
                    self.rewardAd.showAd(vc: sup)
                }
            }).disposed(by: rx.disposeBag)
            
            let nextbtn = Button()
            nextbtn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
            nextbtn.setTitle("下一关", for: .normal)
            nextbtn.setTitleColor(.init(hex: "#C662D5"), for: .normal)
            nextbtn.width = 50.uiX
            nextbtn.height = 13.uiX
            nextbtn.y = 5.uiX + bgImgView.frame.maxY
            nextbtn.x = (width - nextbtn.width)/2.0
            nextbtn.rx.tap.subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                if let sup = self.parentViewController as? PopView {
                    sup.hide()
                }
                self.action?(false)
            }).disposed(by: rx.disposeBag)
            addSubview(nextbtn)
            
        } else {
            btn.rx.tap.subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                if let sup = self.parentViewController as? PopView {
                    sup.hide()
                }
                if let u = UserManager.shared.user {
                    u.gold += (UserManager.shared.configure?.const.guessSongMasonry ?? 0)
                    UserManager.shared.login.accept((u, .change))
                }
                self.action?(false)
            }).disposed(by: rx.disposeBag)
        }
        
        let animation = Animation.named("data", subdirectory: "9")
        let animationView = AnimationView(animation: animation)
        animationView.contentMode = .scaleAspectFill
        animationView.y = -110.uiX
        animationView.width = 150.uiX
        animationView.height = 300.uiX
        animationView.x = (width - animationView.width)/2.0
        animationView.backgroundBehavior = .pauseAndRestore
        addSubview(animationView)
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
}
