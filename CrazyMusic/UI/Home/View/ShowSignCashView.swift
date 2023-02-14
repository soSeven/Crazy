//
//  ShowSignCashView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/8.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation

class ShowSignCashView: UIView {
    
    static var isShow = false
    static var time = 15.0
    static var isChoose = false
    
    init(rect: CGRect, frame: CGRect) {
        
        super.init(frame: frame)
        
        let cPath = UIBezierPath(rect: bounds)
        let a = UIBezierPath(roundedRect: rect, cornerRadius: 10.uiX)
        cPath.append(a)
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.frame = bounds
        shaperLayer.fillColor = UIColor.black.alpha(0.7).cgColor
        shaperLayer.fillRule = .evenOdd
        shaperLayer.path = cPath.cgPath
        
        layer.addSublayer(shaperLayer)
        
        let img = UIImage.create("xsyd-sz-icon")
        let imgView = UIImageView(image: img)
        imgView.size = img.snpSize
        imgView.x = rect.maxX - 10.uiX
        imgView.y = rect.maxY - 10.uiX
        addSubview(imgView)
        
        let ro = CABasicAnimation(keyPath: "transform.scale")
        ro.fromValue = 0.9
        ro.toValue = 1
        ro.duration = 0.5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.autoreverses = true
        ro.fillMode = .forwards
        imgView.layer.add(ro, forKey: "rotationAnimation")
        
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static var showViews = [ShowSignCashView]()
    
    class func show(view: UIView, onView: UIView) {
        
        if showViews.count > 0 {
            return
        }
        if let s = view.superview {
            let rect = s.convert(view.frame, to: onView)
            let v = ShowSignCashView(rect: .init(x: rect.minX - 5.uiX, y: rect.minY, width: rect.width + 10.uiX, height: rect.height + 5.uiX), frame: onView.bounds)
            onView.addSubview(v)
            showViews.append(v)
        }
    }
    
    class func hide() {
        showViews.forEach{ $0.removeFromSuperview() }
        showViews.removeAll()
    }
    
}
