//
//  HomeRightView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/8.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit

class HomeRightView: UIView {
    
    let contentView = UIView()
    
    var btn1: UIButton!
    var btn2: UIButton!
    let numlbl = UILabel()
    
    init(x: CGFloat, y: CGFloat) {
        let rect = CGRect(x: x, y: y, width: 57.uiX, height: 200.uiX)
        super.init(frame: rect)
        contentView.frame = bounds
        addSubview(contentView)
        
        let (item1, btn1) = getItemView(image: "home_img_choose")
        self.btn1 = btn1
        
        
        let (item2, btn2) = getItemView(image: "home_img_exclude")
        self.btn2 = btn2
        
        item2.x = 0
        item2.y = 0
        
        item1.x = 0
        item1.y = item2.frame.maxY + 20.uiX
        
        contentView.addSubview(item1)
        contentView.addSubview(item2)
        
        numlbl.textColor = .init(hex: "#FFFFFF")
        numlbl.font = .init(style: .regular, size: 12.uiX)
        numlbl.backgroundColor = .init(hex: "#FF4362")
        numlbl.cornerRadius = 15.uiX/2.0
        numlbl.textAlignment = .center
        numlbl.text = "0"
        numlbl.width = 15.uiX
        numlbl.height = 15.uiX
        numlbl.x = 34.5.uiX
        numlbl.y = 0.uiX
        contentView.addSubview(numlbl)
        
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
