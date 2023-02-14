//
//  LifePopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/10.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LifePopView: UIView {
    
    let viewModel =  LifePopViewModel()
    
    private let rewardAd: RewardVideoAd
    
    init() {
        
        rewardAd = RewardVideoAd(slotId: "945408904", gdSlotId: "3091023815650824")
        
        let bgImg = UIImage.create("correct_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .bold, size: 18.uiX)
        titleLbl.text = "生命值不足"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 18.uiX
        titleLbl.y = 46.5.uiX
        addSubview(titleLbl)
        
        let closeImg = UIImage.create("choose_icon_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 15.5.uiX
        closeBtn.x = width - closeBtn.width - 19.uiX
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(closeBtn)
        
        let redHeartImg = UIImage.create("correct_img_heart")
        let redHeartView = UIImageView(image: redHeartImg)
        redHeartView.size = redHeartImg.snpSize
        redHeartView.y = 123.5.uiX
        redHeartView.x = (width - redHeartView.width)/2.0
        addSubview(redHeartView)
        
//        let textLbl = UILabel()
//        textLbl.textColor = .init(hex: "#EADADA")
//        textLbl.font = .init(style: .regular, size: 15.uiX)
//        textLbl.text = "快速补充继续游戏？"
//        textLbl.textAlignment = .center
//        textLbl.width = width
//        textLbl.height = 14.uiX
//        textLbl.y = 13.5.uiX + redHeartView.frame.maxY
//        addSubview(textLbl)
        
        let btnImg = UIImage.create("anniu")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 263.5.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController {
                MobClick.event("video_hp_ad")
                self.rewardAd.showAd(vc: sup)
            }
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        let pub = PublishRelay<Void>()
        rewardAd.completion = {
            pub.accept(())
        }
        let input = LifePopViewModel.Input(request: pub.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: {[weak self] s in
            guard let self = self else { return }
            if let s = s, let u = UserManager.shared.login.value.0 {
                u.hp = s.hp
                UserManager.shared.login.accept((u, .change))
            }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
