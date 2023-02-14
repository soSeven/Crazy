//
//  SignCashRedBagItemView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import Lottie

class SignCashRedBagItemView: UIView {
    
    let btn = MusicButton()
    
    init(model: SignCashModel) {
        let frame: CGRect = .init(x: 0, y: 0, width: 54.uiX, height: 54.uiX)
        super.init(frame: frame)
        
//        let bgImg = UIImage.create(model.type == 5 ? "sign_img_box" : "sign_img_package")
//        let bgImgView = UIImageView(image: bgImg)
//        bgImgView.size = bgImg.snpSize
//        bgImgView.center = center
//        addSubview(bgImgView)
        
        let animation = Animation.named("data", subdirectory: model.type == 5 ? "6" : "7")
        let animationView = AnimationView(animation: animation)
        animationView.contentMode = .scaleAspectFill
        if model.type == 5 {
            animationView.width = 100.uiX
            animationView.height = 100.uiX
        } else {
            animationView.width = 60.uiX
            animationView.height = 75.uiX
        }
        animationView.center = center
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        addSubview(animationView)
        animationView.play()
        
        let checkImg = UIImage.create("sign_img_label")
        let checkImgView = UIImageView(image: checkImg)
        checkImgView.size = checkImg.snpSize
        if model.type == 5 {
            checkImgView.x = animationView.frame.maxX - 40.uiX
            checkImgView.y = animationView.frame.minY
        } else {
            checkImgView.x = animationView.frame.maxX - 10.uiX
            checkImgView.y = animationView.frame.minY - checkImgView.height/2.0
        }
        
        addSubview(checkImgView)
        
        btn.frame = bounds
        addSubview(btn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
