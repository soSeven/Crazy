//
//  SoundProgressView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/27.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class SoundProgressView: UIView {
    
    private let maskLayer = CALayer()
    private let progressImgView = UIImageView()
    private let slider = UISlider()
    
    var action: (()->())?
    
    init() {
        
        let bgImg = UIImage.create("sound_bg")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .bold, size: 19.uiX)
        titleLbl.text = "欢迎来到疯狂猜歌"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 19.uiX
        titleLbl.y = 44.5.uiX
        addSubview(titleLbl)
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#EADADA")
        textLbl.font = .init(style: .regular, size: 16.uiX)
        textLbl.text = "请调节到合适的音量开始猜歌吧"
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 15.5.uiX
        textLbl.y = 83.uiX
        addSubview(textLbl)
        
        let soundImg = UIImage.create("sy-icon")
        let soundImgView = UIImageView(image: soundImg)
        soundImgView.size = soundImg.snpSize
        soundImgView.y = 143.uiX
        soundImgView.x = 37.uiX
        addSubview(soundImgView)
        
        let volumeView = MPVolumeView(frame: .zero)
        var volumeSlider: UISlider?
        for s in volumeView.subviews {
            if let sli = s as? UISlider {
                volumeSlider = sli
                break
            }
        }
        volumeView.x = -UIDevice.screenWidth
        addSubview(volumeView)
        
        let sliderImg = UIImage.create("ing-bg")
        var volume = volumeSlider?.value ?? 0
        if volume == 0 {
            volume = AVAudioSession.sharedInstance().outputVolume
        }
        slider.value = volume
        slider.setThumbImage(.create("ylan"), for: .normal)
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.size = sliderImg.snpSize
        slider.center.y = soundImgView.center.y
        slider.x = 76.uiX
        
        let sliderBgImgView = UIImageView(image: sliderImg)
        sliderBgImgView.frame = slider.frame
        
        let progressImg = UIImage.create("lt")
        progressImgView.image = progressImg
        progressImgView.size = progressImg.snpSize
        progressImgView.y = (sliderBgImgView.height - progressImgView.height)/2.0
        progressImgView.x = 1.5.uiX
        sliderBgImgView.addSubview(progressImgView)
        
        maskLayer.frame = .init(x: 0, y: 0, width: CGFloat(slider.value)*progressImgView.width, height: progressImgView.height)
        maskLayer.backgroundColor = UIColor.black.cgColor
        progressImgView.layer.mask = maskLayer
        
        var isClick = false
        slider.rx.controlEvent(.valueChanged).subscribe(onNext: {[weak slider, weak self] _ in
            guard let self = self else { return }
            guard let slider = slider else { return }
            volumeSlider?.value = slider.value
            self.setupVolume(slider.value)
            if !isClick {
                MobClick.event("audio_change_click")
                isClick = true
            }
        }).disposed(by: rx.disposeBag)
        
        addSubview(sliderBgImgView)
        addSubview(slider)
        
        
        let btnImg = UIImage.create("an-kscg")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 212.5.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                let action = self.action
                MobClick.event("audio_decide_click")
                sup.hide(completion: action)
            }
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChange(_:)) , name:Notification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification") , object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    @objc func volumeChange(_ notification:NSNotification) {
        let userInfo = notification.userInfo!
        let volume = userInfo["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        setupVolume(volume)
        slider.value = volume
    }
    
    private func setupVolume(_ volume: Float) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.frame = .init(x: 0, y: 0, width: CGFloat(volume)*progressImgView.width, height: progressImgView.height)
        CATransaction.commit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
