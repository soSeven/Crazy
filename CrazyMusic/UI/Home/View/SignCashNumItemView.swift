//
//  SignCashNumItemView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit

class SignCashNumItemView: UIView {
    
    init(model: SignCashModel) {
        let frame: CGRect = .init(x: 0, y: 0, width: 54.uiX, height: 54.uiX)
        super.init(frame: frame)
        let bgImg = UIImage.create("sign_img_circle")
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.center = center
        addSubview(bgImgView)
        
        let numLbl = UILabel()
        numLbl.font = .init(style: .bold, size: 25.uiX)
        numLbl.textColor = .init(hex: "#FFFFFF")
        numLbl.frame = bounds
        numLbl.textAlignment = .center
        addSubview(numLbl)
        numLbl.text = "\(model.day ?? 0)"
        
        if model.type == 1 {
            let checkImg = UIImage.create("sign_img_complete")
            let checkImgView = UIImageView(image: checkImg)
            checkImgView.size = checkImg.snpSize
            checkImgView.center = center
            addSubview(checkImgView)
        } else if model.type == 2 {
            let signImg = UIImage.create("sign_img_nor")
            let signImgView = UIImageView(image: signImg)
            signImgView.size = signImg.snpSize
            signImgView.center = center
            addSubview(signImgView)
        } else if model.type == 6 {
            let signImg = UIImage.create("dktx-ycz-icon")
            let signImgView = UIImageView(image: signImg)
            signImgView.size = signImg.snpSize
            signImgView.center = center
            addSubview(signImgView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
