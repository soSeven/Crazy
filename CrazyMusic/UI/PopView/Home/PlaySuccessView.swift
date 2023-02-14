//
//  PlaySuccessView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/16.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PlaySuccessView: UIView {
    
    var action: (()->())?
    var nextAction: (()->())?
    
    private let rewardAd: RewardVideoAd
    
    init(cash: Int, level: Int, cashAd: Int) {
        
        YBPlayAudio.success()
        
        rewardAd = RewardVideoAd(slotId: "945408896", gdSlotId: "7031529825951801")
        
        let bgImg = UIImage.create("reward_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 35.uiX)
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
        textLbl.y = 185.5.uiX
        textLbl.text = "+\(cash.cashDigits)元"
        addSubview(textLbl)
        
        let lbl1 = UILabel()
        lbl1.textColor = .init(hex: "#E1DAE6")
        lbl1.font = .init(style: .regular, size: 14.uiX)
        lbl1.y = 237.5.uiX
        lbl1.x = 0
        lbl1.height = 14.uiX
        lbl1.width = width
        lbl1.attributedText = getAttributedText(n: level)
        lbl1.textAlignment = .center
        addSubview(lbl1)
        
        let btnImg = UIImage.create("an-f2-5bjl")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 267.5.uiX
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController {
                self.rewardAd.showAd(vc: sup)
            }
            MobClick.event("video_passPacket")
        }).disposed(by: rx.disposeBag)
        
        rewardAd.completion = {[weak self] in
            guard let self = self else { return }
            self.action?()
            if let u = UserManager.shared.login.value.0 {
                var doubleNumber = cashAd - cash
                if doubleNumber < 0 {
                    doubleNumber = 0
                }
                u.cash += doubleNumber
                UserManager.shared.login.accept((u, .change))
            }
            let d = PlaySuccessDoubleView(cash: cashAd)
            PopView.show(view: d)
        }
        
        let closeBtn = MusicButton()
        closeBtn.width = 150.uiX
        closeBtn.height = 14.uiX
        closeBtn.y = bgImgView.frame.maxY + 18.uiX
        closeBtn.x = (width - closeBtn.width)/2.0
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            MobClick.event("passPacket_double_no")
            self.nextAction?()
        }).disposed(by: rx.disposeBag)
        closeBtn.isUserInteractionEnabled = false
        addSubview(closeBtn)
        var countDown = 3
        closeBtn.setTitle("\(countDown)s", for: .normal)
        closeBtn.titleLabel?.font = .init(style: .regular, size: 15.uiX)
        closeBtn.setTitleColor(.init(hex: "#C662D5"), for: .normal)
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
            countDown -= 1
            if countDown <= 0 {
                closeBtn.isUserInteractionEnabled = true
                closeBtn.setTitle("下一首，继续赚钱", for: .normal)
            } else {
                closeBtn.setTitle("\(countDown)s", for: .normal)
            }
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
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#E1DAE5")
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        
        let a1 = NSMutableAttributedString(string: "距离下次提现机会还差", attributes: att1)
        let a2 = NSAttributedString(string: "\(n)", attributes: att2)
        let a3 = NSAttributedString(string: "首歌", attributes: att1)
        a1.append(a2)
        a1.append(a3)
        return a1
    }
    
}
