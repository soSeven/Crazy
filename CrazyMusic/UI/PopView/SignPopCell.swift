//
//  SignPopCell.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignPopCell: CollectionViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 12.uiX)
        return lbl
    }()
    
    lazy var numLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 9.uiX)
        return lbl
    }()
    
    lazy var priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#827A77")
        lbl.font = .init(style: .bold, size: 11.uiX)
        return lbl
    }()
    
    lazy var bgImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("qdtx-yqd-bg3"))
        return v
    }()
    
    lazy var markImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("qdtx-ylhb-ty-icon"))
        return v
    }()
    
    lazy var redBagImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("qdtx-wlhb-tb-icon"))
        return v
    }()
    
    let redBtn = MusicButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().priority(900)
            make.size.equalTo(bgImgView.image!.snpSize).priority(900)
        }
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.uiX)
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(numLbl)
        numLbl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4.uiX)
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(markImgView)
        contentView.addSubview(redBagImgView)
        
        redBagImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33.5.uiX)
            make.centerX.equalToSuperview()
            make.size.equalTo(redBagImgView.image!.snpSize)
        }
        
        markImgView.snp.makeConstraints { make in
            make.bottom.equalTo(redBagImgView.snp.bottom).offset(1.uiX)
            make.centerX.equalToSuperview()
            make.size.equalTo(markImgView.image!.snpSize)
        }
        
        contentView.addSubview(redBtn)
        redBtn.snp.makeConstraints { make in
            make.edges.equalTo(redBagImgView)
        }
        
        contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.centerX.equalTo(redBagImgView)
            make.top.equalTo(redBagImgView).offset(2.5.uiX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: SignListCellViewModel) {
        titleLbl.text = model.text.value
        cellDisposeBag = DisposeBag()
        var btnDisposeBag = DisposeBag()
        Observable.combineLatest(model.isToday.asObservable(), model.isActive.asObservable(), model.cash.asObservable()).subscribe(onNext: {[weak self] (isToday, isActive, cash) in
            guard let self = self else { return }
            btnDisposeBag = DisposeBag()
            if isToday > 0 {
                self.bgImgView.image = .create("qdtx-yqd-bg")
                self.titleLbl.textColor = .init(hex: "#A43104")
                if isActive > 0 {
                    self.numLbl.attributedText = self.getAttributedText(n: model.gold.value, isActive: true)
                } else {
                    self.numLbl.attributedText = self.getAttributedText(n: model.gold.value, isActive: false)
                }
                if cash > 0 {
                    self.redBagImgView.image = .create("qdtx-jtykhb-icon")
                    self.priceLbl.isHidden = false
                    self.priceLbl.textColor = .init(hex: "#FD0C47")
                } else {
                    self.redBagImgView.image = .create("qdtx-wlhb-tb-icon")
                    self.priceLbl.isHidden = true
                }
            } else {
                if isActive > 0 {
                    self.bgImgView.image = .create("qdtx-yqd-bg2")
                    self.titleLbl.textColor = .init(hex: "#FFFFFF")
                    self.numLbl.attributedText = self.getAttributedText(n: model.gold.value, isActive: true)
                } else {
                    self.bgImgView.image = .create("qdtx-yqd-bg3")
                    self.titleLbl.textColor = .init(hex: "#FFFFFF")
                    self.numLbl.attributedText = self.getAttributedText(n: model.gold.value, isActive: false)
                }
                if cash > 0 {
                    self.priceLbl.isHidden = false
                    self.priceLbl.textColor = .init(hex: "#827A77")
                    self.redBagImgView.image = .create("qdtx-ztylhb-icon")
                } else {
                    self.priceLbl.isHidden = true
                    self.redBagImgView.image = .create("qdtx-wlhb-tb-icon")
                }
            }
            
            self.priceLbl.text = "\(cash.cash)元"
            
            self.redBagImgView.layer.removeAllAnimations()
            if isActive > 0, cash == 0 {
                
                let ro = CABasicAnimation(keyPath: "transform.rotation.z")
                ro.fromValue = -Double.pi/10
                ro.toValue = Double.pi/10
                ro.autoreverses = true
                ro.duration = 0.5
                ro.repeatCount = HUGE
                ro.isRemovedOnCompletion = false
                ro.fillMode = .forwards
                self.redBagImgView.layer.add(ro, forKey: "rotationAnimation")
                
                self.redBtn.rx.tap.subscribe(onNext: { _ in
                    model.openRedBag.onNext(model)
                }).disposed(by: btnDisposeBag)
    
            }
        }).disposed(by: cellDisposeBag)
    }
    
    private func getAttributedText(n: Int, isActive: Bool) -> NSAttributedString {
        let img = UIImage.create("qdtx-jbjl-jb-icon")
        let att = NSTextAttachment()
        att.image = img
        att.bounds = .init(x: 0, y: -2.uiX, width: 10.uiX, height: 10.uiX)
        let a = NSAttributedString(attachment: att)
        
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 9.uiX),
            .foregroundColor: UIColor(hex: "#ffffff")
        ]
        
        let a1 = NSMutableAttributedString(string: isActive ? "已领 \(n) " : "+\(n) ", attributes: att1)
        a1.append(a)
        return a1
    }
    
}
