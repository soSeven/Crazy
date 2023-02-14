//
//  DiamondRedBagView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DiamondRedBagView: UIView {
    
    let viewModel =  DiamondRedBagViewModel()
    
//    private let rewardAd: RewardVideoAd
    
    init(action: @escaping ()->()) {
        
        YBPlayAudio.success()
        
//        rewardAd = RewardVideoAd(slotId: "945425204", gdSlotId: "1071124815551806")
        
        let bgImg = UIImage.create("diamond_img_red_envelopes")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFECC5")
        titleLbl.font = .init(style: .medium, size: 21.uiX)
        titleLbl.text = "每\(UserManager.shared.configure?.songAd.convertGold ?? 0)金币开1个红包"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 20.uiX
        titleLbl.y = 108.uiX
        addSubview(titleLbl)
        
        let titleLbl2 = UILabel()
        titleLbl2.textColor = .init(hex: "#FED5A4")
        titleLbl2.font = .init(style: .regular, size: 14.uiX)
        titleLbl2.text = "我的金币：\(UserManager.shared.user?.gold ?? 0)"
        titleLbl2.textAlignment = .center
        titleLbl2.width = width
        titleLbl2.height = 13.uiX
        titleLbl2.y = 342.5.uiX
        addSubview(titleLbl2)
        
        let closeImg = UIImage.create("diamond_icon_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 12.uiX
        closeBtn.x = width - closeBtn.width - 12.5.uiX
        addSubview(closeBtn)
        
        let pub = PublishRelay<Void>()
        let btnImg = UIImage.create("diamond_img_open")
        let btn = UIButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 239.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: { _ in
            MobClick.event("openPacket_fail")
            pub.accept(())
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
        
//        rewardAd.completion = {
//            pub.accept(())
//        }
//
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        let input = DiamondRedBagViewModel.Input(request: pub.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: { s in
            if let s = s, let u = UserManager.shared.login.value.0 {
                u.cash += s.cash
                u.gold -= (UserManager.shared.configure?.songAd.convertGold ?? 0)
                u.convert += 1
                if u.gold < 0 {
                    u.gold = 0
                }
                UserManager.shared.login.accept((u, .change))
                let cash = CashPopView(num: Float(s.cash) / 10000, type: .play)
                cash.btn.rx.tap.subscribe(onNext: { _ in
                    action()
                }).disposed(by: cash.rx.disposeBag)
                PopView.show(view: cash)
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

