//
//  ShowDeleteView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/31.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import Lottie

class ShowDeleteView: UIView {
    
    static var isShow = false
    static var time = 15.0
    static var isChoose = false
    
    init(rect: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        let cPath = UIBezierPath(rect: bounds)
        let a = UIBezierPath(roundedRect: rect, cornerRadius: 5.uiX)
        cPath.append(a)
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.frame = bounds
        shaperLayer.fillColor = UIColor.black.alpha(0.7).cgColor
        shaperLayer.fillRule = .evenOdd
        shaperLayer.path = cPath.cgPath
        
        layer.addSublayer(shaperLayer)
        
//        isUserInteractionEnabled = false
        
        let animation = Animation.named("data", subdirectory: "11")
        let animationView = AnimationView(animation: animation)
        animationView.contentMode = .scaleAspectFill
        animationView.width = 40.uiX
        animationView.height = 20.uiX
        animationView.y = rect.center.y - animationView.height/2.0
        animationView.x = rect.minX - animationView.width - 5.uiX
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        addSubview(animationView)
        animationView.play()
        
        let lbl = UILabel()
        lbl.text = "为你排除一个错误答案"
        lbl.width = 200.uiX
        lbl.height = 15.uiX
        lbl.y = rect.center.y - lbl.height/2.0
        lbl.x = animationView.x - 10.uiX - lbl.width
        lbl.textColor = .white
        lbl.textAlignment = .right
        lbl.font = .init(style: .regular, size: 14.uiX)
        addSubview(lbl)
        
        let btn = MusicButton()
        btn.frame = bounds
        addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
//            ShowDeleteView.isShow = false
            self.removeFromSuperview()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func show(view: UIView) {
        if isChoose {
            return
        }
        if isShow {
            return
        }
        isShow = true
        if let keyWindow = UIApplication.shared.keyWindow, let s = view.superview {
            let rect = s.convert(view.frame, to: keyWindow)
            let v = ShowDeleteView(rect: .init(x: rect.minX - 5.uiX, y: rect.minY - 10.uiX, width: rect.width + 10.uiX, height: rect.height + 20.uiX))
            keyWindow.addSubview(v)
        }
    }
    
//    class func hide() {
//        if let keyWindow = UIApplication.shared.keyWindow {
//            keyWindow.subviews.filter{$0 is ShowDeleteView}.forEach{$0.removeFromSuperview()}
//        }
//    }
}
