//
//  TimeRedBagView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TimeRedBagView: UIView {
    
    let viewModel: TimeRedBagViewModel
    
    private let rewardAd: RewardVideoAd
    
    init(action: @escaping ()->(), success: @escaping ()->()) {
        
        YBPlayAudio.success()
        
        viewModel = TimeRedBagViewModel()
        rewardAd = RewardVideoAd(slotId: "945409812", gdSlotId: "2091623845358898")
        
        let bgImg = UIImage.create("diamond_img_red_envelopes")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FED5A4")
        titleLbl.font = .init(style: .regular, size: 16.uiX)
        titleLbl.text = "恭喜你获得了一个"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 15.5.uiX
        titleLbl.y = 59.uiX
        addSubview(titleLbl)
        
        let titleLbl1 = UILabel()
        titleLbl1.textColor = .init(hex: "#FED5A4")
        titleLbl1.font = .init(style: .medium, size: 23.uiX)
        titleLbl1.text = "在线奖励红包"
        titleLbl1.textAlignment = .center
        titleLbl1.width = width
        titleLbl1.height = 22.uiX
        titleLbl1.y = 97.uiX
        addSubview(titleLbl1)
        
        let titleLbl2 = UILabel()
        titleLbl2.textColor = .init(hex: "#FED5A4")
        titleLbl2.font = .init(style: .medium, size: 14.uiX)
        let time = UserManager.shared.configure?.const.timerCashTime ?? 0
        let m = time / 60
        let s = time % 60
        let text = String(format: "%.2d:%.2d", m, s)
        titleLbl2.text = "再过\(text)可领取下个额外红包"
        titleLbl2.textAlignment = .center
        titleLbl2.width = width
        titleLbl2.height = 13.5.uiX
        titleLbl2.y = 171.5.uiX
        addSubview(titleLbl2)
        
        let closeImg = UIImage.create("diamond_icon_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 12.uiX
        closeBtn.x = width - closeBtn.width - 12.5.uiX
        addSubview(closeBtn)
        
        let btnImg = UIImage.create("diamond_img_open")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 239.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            YBPlayAudio.awardClick()
            if let sup = self.parentViewController {
                MobClick.event("video_onlinePacket")
                self.rewardAd.showAd(vc: sup)
            }
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
        
        let adBtn = UIButton()
        adBtn.setTitle("看视频领取", for: .normal)
        adBtn.setTitleColor(.init(hex: "#FAB98F"), for: .normal)
        adBtn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
        adBtn.width = 80.uiX
        adBtn.height = 13.uiX
        adBtn.y = 342.5.uiX
        adBtn.x = (width - adBtn.width)/2.0
        addSubview(adBtn)
        adBtn.isUserInteractionEnabled = false
        
        let pub = PublishRelay<Void>()
        rewardAd.completion = {
            pub.accept(())
        }
        
        var isFromClose = false
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            isFromClose = true
            if let sup = self.parentViewController {
                MobClick.event("video_onlinePacket_close")
                self.rewardAd.showAd(vc: sup)
            }
        }).disposed(by: rx.disposeBag)
        
        let input = TimeRedBagViewModel.Input(request: pub.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: {[weak self] s in
            guard let self = self else { return }
            success()
            if let s = s, let u = UserManager.shared.login.value.0 {
                u.cash += s.cash
                UserManager.shared.login.accept((u, .change))
                if isFromClose {
                    if let sup = self.parentViewController as? PopView {
                        sup.hide()
                    }
                } else {
                    let cash = CashPopView(num: Float(s.cash) / 10000,  type: .cash)
                    cash.btn.rx.tap.subscribe(onNext: { _ in
                        action()
                    }).disposed(by: cash.rx.disposeBag)
                    PopView.show(view: cash)
                }
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

