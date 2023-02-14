//
//  ShowSignGuideView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/8.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation

class ShowSignGuideView: UIView {
    
    static var isShow = false
    static var time = 15.0
    static var isChoose = false
    
    func showStep1(view: UIView, onView: UIView, action: @escaping (ShowSignGuideView)->()) {
        guard let s = view.superview else {
            return
        }
        var rect = s.convert(view.frame, to: onView)
        rect = CGRect(x: rect.minX - 10.uiX, y: rect.minY - 10.uiX, width: rect.width + 20.uiX, height: rect.height + 20.uiX)
        
        let cPath = UIBezierPath(rect: bounds)
        let a = UIBezierPath(roundedRect: rect, cornerRadius: rect.height/2.0)
        cPath.append(a)
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.frame = bounds
        shaperLayer.fillColor = UIColor.black.alpha(0.8).cgColor
        shaperLayer.fillRule = .evenOdd
        shaperLayer.path = cPath.cgPath
        
        layer.addSublayer(shaperLayer)
        
        let lineImg = UIImage.create("xsyd-zy-icon")
        let lineImgView = UIImageView(image: lineImg)
        lineImgView.size = lineImg.snpSize
        lineImgView.y = rect.maxY
        lineImgView.center.x = rect.center.x
        addSubview(lineImgView)
        
        let textLbl = UILabel()
        textLbl.text = "每天收集满10个闯关红包\n为你自动打卡哦"
        textLbl.font = .init(style: .regular, size: 15.uiX)
        textLbl.textColor = .white
        textLbl.numberOfLines = 0
        textLbl.textAlignment = .center
        textLbl.height = 50.uiX
        textLbl.width = width
        textLbl.y = lineImgView.frame.maxY + 11.uiX
        addSubview(textLbl)
        
        let btn = MusicButton()
        btn.height = 27.uiX
        btn.width = 98.uiX
        btn.y = textLbl.frame.maxY + 28.uiX
        btn.borderWidth = 1.uiX
        btn.borderColor = .white
        btn.cornerRadius = btn.height/2.0
        btn.center.x = center.x
        addSubview(btn)
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            action(self)
        }).disposed(by: rx.disposeBag)
        
        onView.addSubview(self)
    }
    
    func showStep2(view: UIView, onView: UIView, action: @escaping (ShowSignGuideView)->()) {
        
        removeSubviews()
        layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        
        guard let s = view.superview else {
            return
        }
        var rect = s.convert(view.frame, to: onView)
        rect = CGRect(x: rect.minX - 10.uiX, y: rect.minY - 30.uiX, width: rect.width + 60.uiX, height: rect.height + 40.uiX)
        
        let cPath = UIBezierPath(rect: bounds)
        let a = UIBezierPath(roundedRect: rect, cornerRadius: 10.uiX)
        cPath.append(a)
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.frame = bounds
        shaperLayer.fillColor = UIColor.black.alpha(0.8).cgColor
        shaperLayer.fillRule = .evenOdd
        shaperLayer.path = cPath.cgPath
        
        layer.addSublayer(shaperLayer)
        
        let lineImg = UIImage.create("xsyd-zy-icon")
        let lineImgView = UIImageView(image: lineImg)
        lineImgView.size = lineImg.snpSize
        lineImgView.y = rect.maxY
        lineImgView.center.x = rect.center.x
        addSubview(lineImgView)
        
        let textLbl = UILabel()
        textLbl.text = "连续打卡5天即可\n额外提现1元"
        textLbl.font = .init(style: .regular, size: 15.uiX)
        textLbl.textColor = .white
        textLbl.numberOfLines = 0
        textLbl.textAlignment = .center
        textLbl.height = 50.uiX
        textLbl.width = width
        textLbl.y = lineImgView.frame.maxY + 11.uiX
        addSubview(textLbl)
        
        let btn = MusicButton()
        btn.height = 27.uiX
        btn.width = 98.uiX
        btn.y = textLbl.frame.maxY + 28.uiX
        btn.borderWidth = 1.uiX
        btn.borderColor = .white
        btn.cornerRadius = btn.height/2.0
        btn.center.x = center.x
        addSubview(btn)
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            action(self)
        }).disposed(by: rx.disposeBag)
        
    }
    
    func showStep3(view: UIView, onView: UIView, action: @escaping (ShowSignGuideView)->()) {
        
        removeSubviews()
        layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        
        guard let s = view.superview else {
            return
        }
        var rect = s.convert(view.frame, to: onView)
        rect = CGRect(x: rect.minX - 20.uiX, y: rect.minY - 30.uiX, width: rect.width + 60.uiX, height: rect.height + 40.uiX)
        
        let cPath = UIBezierPath(rect: bounds)
        let a = UIBezierPath(roundedRect: rect, cornerRadius: 18.uiX)
        cPath.append(a)
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.frame = bounds
        shaperLayer.fillColor = UIColor.black.alpha(0.8).cgColor
        shaperLayer.fillRule = .evenOdd
        shaperLayer.path = cPath.cgPath
        
        layer.addSublayer(shaperLayer)
        
        let lineImg = UIImage.create("xsyd-zy-icon")
        let lineImgView = UIImageView(image: lineImg)
        lineImgView.size = lineImg.snpSize
        lineImgView.y = rect.minY - lineImgView.height
        lineImgView.center.x = rect.center.x
        addSubview(lineImgView)
        
        let textLbl = UILabel()
        textLbl.text = "连续打卡30天\n更可提现30元"
        textLbl.font = .init(style: .regular, size: 15.uiX)
        textLbl.textColor = .white
        textLbl.numberOfLines = 0
        textLbl.textAlignment = .center
        textLbl.height = 50.uiX
        textLbl.width = width
        textLbl.y = lineImgView.frame.minY - 11.uiX - textLbl.height
        textLbl.center.x = rect.center.x
        addSubview(textLbl)
        
        let btn = MusicButton()
        btn.height = 27.uiX
        btn.width = 98.uiX
        btn.x = rect.maxX + 20.uiX
        btn.borderWidth = 1.uiX
        btn.borderColor = .white
        btn.cornerRadius = btn.height/2.0
        btn.center.y = rect.center.y
        addSubview(btn)
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            action(self)
            self.removeFromSuperview()
        }).disposed(by: rx.disposeBag)
        
    }
    
}
