//
//  SignPopCell3.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/16.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignPopCell3: CollectionViewCell {
    
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
    
    lazy var bgImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("qdtx-lx7t-bg1"))
        return v
    }()
    
    lazy var markImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("qdtx-lx7t-gx"))
        return v
    }()
    
    lazy var redBagImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("qdtx-lx7t-cjof-icon"))
        return v
    }()
    
    let btn = MusicButton()
    
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
            make.bottom.equalToSuperview().offset(-10.uiX)
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(markImgView)
        contentView.addSubview(redBagImgView)
        
        redBagImgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10.5.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.size.equalTo(redBagImgView.image!.snpSize)
        }
        
        markImgView.snp.makeConstraints { make in
            make.center.equalTo(redBagImgView)
            make.size.equalTo(markImgView.image!.snpSize)
        }
        
        let btnImg = UIImage.create("qdtx-lx7t-qtx-an")
        btn.setImage(btnImg, for: .normal)
        contentView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-9.5.uiX)
            make.bottom.equalToSuperview().offset(-18.uiX)
            make.size.equalTo(btnImg.snpSize)
        }
        
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        markImgView.layer.add(ro, forKey: "rotationAnimation")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: SignListCellViewModel) {
        titleLbl.text = model.text.value
        cellDisposeBag = DisposeBag()
        var btnDisposeBag = DisposeBag()
        Observable.combineLatest(model.isToday.asObservable(), model.isActive.asObservable()).subscribe(onNext: {[weak self] (isToday, isActive) in
            btnDisposeBag = DisposeBag()
            guard let self = self else { return }
            if isToday > 0 {
                self.bgImgView.image = .create("qdtx-lx7t-bg2")
                self.titleLbl.textColor = .init(hex: "#A43104")
                if isActive > 0 {
                    self.numLbl.attributedText = self.getAttributedText(n: model.gold.value, isActive: true)
                } else {
                    self.numLbl.attributedText = self.getAttributedText(n: model.gold.value, isActive: false)
                }
            } else {
                self.bgImgView.image = .create("qdtx-lx7t-bg1")
                self.titleLbl.textColor = .init(hex: "#FFFFFF")
                self.numLbl.attributedText = self.getAttributedText(n: model.gold.value, isActive: false)
            }
            
            if isActive > 0{
                self.btn.rx.tap.subscribe(onNext: { _ in
                    model.openCash.onNext(model)
                }).disposed(by: btnDisposeBag)
            }
            
        }).disposed(by: cellDisposeBag)
    }
    
    private func getAttributedText(n: Int, isActive: Bool) -> NSAttributedString {
        let img = UIImage.create("qdtx-jbjl-jb-icon")
        let att = NSTextAttachment()
        att.image = img
        att.bounds = .init(x: 0, y: -2.uiX, width: 10.uiX, height: 10.5.uiX)
        let a = NSAttributedString(attachment: att)
        
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 12.5.uiX),
            .foregroundColor: UIColor(hex: "#FFE700")
        ]
        
        let a1 = NSMutableAttributedString(string: isActive ? "已领  \(n) " : "+\(n) ", attributes: att1)
        a1.append(a)
        return a1
    }
    
}
