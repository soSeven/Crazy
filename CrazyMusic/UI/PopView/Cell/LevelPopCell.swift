//
//  LevelPopCell.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import YYText
import RxCocoa
import RxSwift

class LevelPopCell: CollectionViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    
    lazy var coinLbl: YYLabel = {
        let lbl = YYLabel()
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var markImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("rw-rwk"))
        return v
    }()
    
    let btn = MusicButton()
    var btnDisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(markImgView)
        markImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10.5.uiX)
        }
        
        contentView.addSubview(coinLbl)
        coinLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(88.uiX)
        }
        
        let btnImg = UIImage.create("rw-wwc-an")
        contentView.addSubview(btn)
        btn.setImage(btnImg, for: .normal)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(199.uiX)
            make.size.equalTo(btnImg.snpSize)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: LevelPopCellViewModel) {
        cellDisposeBag = DisposeBag()
        titleLbl.text = "\(model.level.value)关"
        coinLbl.attributedText = getAttributedText(n: model.gold.value)
        model.type.subscribe(onNext: {[weak self] type in
            guard let self = self else { return }
            self.btnDisposeBag = DisposeBag()
            switch type {
            case 1:
                self.btn.setImage(.create("rw-wwc-an"), for: .normal)
            case 2:
                self.btn.setImage(.create("rw-lq-an"), for: .normal)
                self.btn.rx.tap.subscribe(onNext: { _ in
                    model.openCoin.onNext(model)
                }).disposed(by: self.btnDisposeBag)
            default:
                self.btn.setImage(.create("rw-ylq-an"), for: .normal)
            }
        }).disposed(by: cellDisposeBag)
        
    }
    
    private func getAttributedText(n: Int) -> NSAttributedString {
        let img = UIImage.create("rw-jb-icon")
        let a = NSAttributedString.yy_attachmentString(withContent: img, contentMode: .center, attachmentSize: img.snpSize, alignTo: .init(style: .regular, size: 12.uiX), alignment: .center)
        
        
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 12.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        
        let a1 = NSMutableAttributedString(string: "奖励 ", attributes: att1)
        let a2 = NSAttributedString(string: " \(n)", attributes: att1)
        a1.append(a)
        a1.append(a2)
        return a1
    }
    
}
