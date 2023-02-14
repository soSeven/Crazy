//
//  NewUserPopView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/21.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation

class NewUserPopView: UIView {
    
    var action: (()->())?
    
    init() {
        
        let bgImg = UIImage.create("xsfl-bj")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 0
        addSubview(bgImgView)
        
        let redHeartImg = UIImage.create("xsfl-wa")
        let redHeartView = UIImageView(image: redHeartImg)
        redHeartView.size = redHeartImg.snpSize
        redHeartView.y = 63.5.uiX
        redHeartView.x = (width - redHeartView.width)/2.0
        addSubview(redHeartView)
        
        let btnImg = UIImage.create("xsfl-kscg-an")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = height - btn.height - 27.uiX
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            self.action?()
            MobClick.event("Start_songs")
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
}
