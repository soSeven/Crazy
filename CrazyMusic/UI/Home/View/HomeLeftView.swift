//
//  HomeLeftView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/8.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import ChainableAnimations
import RxCocoa
import RxSwift
import Lottie

class HomeLeftView: UIView {
    
    let contentView = UIView()
    
    var btn1: UIButton!
    var btn2: UIButton!
    let timeLbl = UILabel()
    
    private var redBagTime = 0

    init(x: CGFloat, y: CGFloat) {
        let rect = CGRect(x: x, y: y, width: 57.uiX, height: 200.uiX)
        super.init(frame: rect)
        contentView.frame = bounds
        addSubview(contentView)
        
        let (item2, btn2) = getItemView(image: "sy-tdtx-icon")
        self.btn2 = btn2
        item2.x = 0
        item2.y = 13.uiX
        contentView.addSubview(item2)
        
        let (item1, btn1) = getItemView(image: "sy-lhb-icn")
        self.btn1 = btn1
        item1.x = 0
        item1.y = item2.frame.maxY + 39.uiX
        
        let redHeartImg = UIImage.create("home_img_light")
        let redHeartView = UIImageView(image: redHeartImg)
        redHeartView.size = redHeartImg.snpSize
        redHeartView.center = item1.center
//        redHeartView.y = 5.uiX
        contentView.addSubview(redHeartView)
        contentView.addSubview(item1)
        
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = false
        ro.fillMode = .forwards
        redHeartView.layer.add(ro, forKey: "rotationAnimation")
        
        timeLbl.textColor = .init(hex: "#B0F7FF")
        timeLbl.font = .init(style: .regular, size: 10.uiX)
        timeLbl.textAlignment = .center
        timeLbl.width = width
        timeLbl.height = 8.uiX
        timeLbl.x = 0
        timeLbl.y = item1.frame.maxY + 2.uiX
        contentView.addSubview(timeLbl)
        
//        btn2 = MusicButton()
        
//        let animation = Animation.named("data", subdirectory: "10")
//        let animationView = AnimationView(animation: animation)
//        animationView.contentMode = .scaleAspectFill
//        animationView.y = item1.frame.maxY + 23.uiX
//        animationView.width = 44.uiX
//        animationView.height = 53.uiX
//        animationView.x = (width - animationView.width)/2.0
//        animationView.loopMode = .loop
//        animationView.backgroundBehavior = .pauseAndRestore
//        contentView.addSubview(animationView)
//        animationView.play()
        
//        btn2.frame = animationView.frame
//        contentView.addSubview(btn2)

        redBagTime = UserManager.shared.user?.timerCashTime ?? 0
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.redBagTime -= 1
            let m = self.redBagTime / 60
            let s = self.redBagTime % 60
            self.timeLbl.text = String(format: "%.2d:%.2d", m, s)
            if self.redBagTime <= 0 {
                self.timeLbl.isHidden = true
                self.btn1.isUserInteractionEnabled = true
                redHeartView.isHidden = false
            } else {
                redHeartView.isHidden = true
                self.timeLbl.isHidden = false
                self.btn1.isUserInteractionEnabled = false
            }
        }).disposed(by: rx.disposeBag)
        
    }
    
    func resetTime() {
        redBagTime = UserManager.shared.configure?.const.timerCashTime ?? 0
    }
    
    private func getItemView(image: String) -> (UIView, UIButton) {
        
        let view = UIView()
        view.width = contentView.width
        
        let img = UIImage.create(image)
        let imgView = MusicButton()
        imgView.setImage(img, for: .normal)
        imgView.size = img.snpSize
        imgView.y = 0
        imgView.x = (view.width - imgView.width)/2.0
        
        view.height = imgView.frame.maxY
//        view.backgroundColor = .green
        view.addSubview(imgView)
        
        return (view, imgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
