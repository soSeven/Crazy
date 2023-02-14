//
//  MusicPopCell.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit

class MusicPopCell: CollectionViewCell {
    
    lazy var markLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 16.uiX)
        lbl.text = "华语流行"
        return lbl
    }()
    
    lazy var markImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("choose_img_btn2"))
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(markImgView)
        markImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(markLbl)
        markLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: ConfigureMusicTypeModel, selected: Bool) {
        markLbl.text = model.name
        markImgView.image = .create(selected ? "choose_img_btn1" : "choose_img_btn2")
    }
    
}
