//
//  PlaySuccessDoubleView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/16.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PlaySuccessDoubleView: UIView {
    
    init(cash: Int) {
        
        YBPlayAudio.success()
        
        let bgImg = UIImage.create("reward_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 35.uiX)
        super.init(frame: frame)
        
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
        textLbl.y = 77.uiX + redHeartView.frame.maxY
        textLbl.text = "+\(cash.cashDigits)元"
        addSubview(textLbl)
        
        let lbl1 = UILabel()
        lbl1.textColor = .init(hex: "#E1DAE5")
        lbl1.font = .init(style: .regular, size: 14.uiX)
        lbl1.y = 49.uiX + redHeartView.frame.maxY
        lbl1.x = 0
        lbl1.height = 14.uiX
        lbl1.width = width
        lbl1.text = "看视频辛苦啦，获得翻倍奖励"
        lbl1.textAlignment = .center
        addSubview(lbl1)

        Observable.just(1).delay(.seconds(2), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
}
