//
//  PayListCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/4.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class PayListCell: CollectionViewCell {
    
    lazy var priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#333333")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    
    lazy var markLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 9.uiX)
        return lbl
    }()
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.cornerRadius = 5.uiX
        return v
    }()
    
    lazy var markImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("withdraw_img_label01"))
        return v
    }()
    
    lazy var chooseImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("withdraw_img_choose"))
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(3.5.uiX)
            make.top.equalToSuperview().offset(3.5.uiX)
            make.bottom.right.equalToSuperview()
        }
        
        bgView.addSubview(priceLbl)
        
        priceLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(markImgView)
        markImgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(markImgView.image!.snpSize)
        }
        
        markImgView.addSubview(markLbl)
        markLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-2.uiX)
            make.centerX.equalToSuperview()
        }
        
        bgView.addSubview(chooseImgView)
        chooseImgView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.size.equalTo(chooseImgView.image!.snpSize)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: ConfigurePriceModel, isShowFinger: Bool) {
        priceLbl.text = String(format: "%.2f元", Float(model.cash ?? 0)/10000.0)
        markLbl.text = model.text
        if model.type == 1 {
            markImgView.image = .create("tx-dhs-icon")
            markLbl.isHidden = false
            markImgView.isHidden = false
        } else {
            markImgView.image = .create("tx-hs-icon")
            markLbl.isHidden = true
            markImgView.isHidden = true
        }
        markImgView.snp.remakeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(markImgView.image!.snpSize)
        }
    }
    
}
