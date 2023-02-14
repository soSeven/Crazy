//
//  MyDiamondTableCell.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MyDiamondTableCell: TableViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#333333")
        lbl.font = .init(style: .regular, size: 15.uiX)
        return lbl
    }()
    
    lazy var progressLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#808080")
        lbl.font = .init(style: .regular, size: 13.uiX)
        return lbl
    }()
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#808080")
        lbl.font = .init(style: .regular, size: 13.uiX)
        return lbl
    }()
    
    lazy var progressView: UIView = {
        let lbl = UIView()
        lbl.backgroundColor = .init(hex: "#FDA500")
        return lbl
    }()
    
    let btn = MusicButton()
    let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.top.equalToSuperview().offset(18.uiX)
        }
        
        let progressBgView = UIView()
        progressBgView.backgroundColor = .init(hex: "#E0E0E0")
        progressBgView.cornerRadius = 3.uiX
        contentView.addSubview(progressBgView)
        progressBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.bottom.equalToSuperview().offset(-21.uiX)
            make.height.equalTo(6.uiX)
            make.width.equalTo(98.uiX)
        }
        
        progressView.frame = .init(x: 0, y: 0, width: 98.uiX, height: 6.uiX)
        progressBgView.addSubview(progressView)
        
        contentView.addSubview(progressLbl)
        progressLbl.snp.makeConstraints { make in
            make.centerY.equalTo(progressBgView)
            make.left.equalTo(progressBgView.snp.right).offset(9.uiX)
        }
        
        let img = UIImage.create("diamond_img_btn")
        btn.setBackgroundImage(img, for: .normal)
        contentView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
            make.top.equalToSuperview().offset(11.uiX)
        }
        
        contentView.addSubview(textLbl)
        textLbl.snp.makeConstraints { make in
            make.centerX.equalTo(btn)
            make.bottom.equalToSuperview().offset(-12.uiX)
        }
        
        
        lineView.backgroundColor = .init(hex: "#F5F5F5")
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getAttributedText(n: Int) -> NSAttributedString {
        let img = UIImage.create("diamond_icon_small")
        let att = NSTextAttachment()
        att.image = img
        let a = NSAttributedString(attachment: att)
        
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 12.uiX),
            .foregroundColor: UIColor(hex: "#999999")
        ]
        
        let a1 = NSMutableAttributedString(string: "消耗 ", attributes: att1)
        let a2 = NSAttributedString(string: " \(n)", attributes: att1)
        a1.append(a)
        a1.append(a2)
        return a1
    }
    
    private func setupProgress(progress: CGFloat) {
        progressView.frame = .init(x: 0, y: 0, width: (98.uiX)*progress, height: 6.uiX)
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: MyDiamondCellViewModel) {
        cellDisposeBag = DisposeBag()
        
        viewModel.gold.bind {[weak self] g in
            guard let self = self else { return }
            self.textLbl.attributedText = self.getAttributedText(n: g)
        }.disposed(by: cellDisposeBag)
        
        Observable.combineLatest(viewModel.level, viewModel.levelToday).bind {[weak self] (level, today) in
            guard let self = self else { return }
            self.titleLbl.text = "通关\(level)关"
            self.progressLbl.text = "\(today)/\(level)"
            if level > 0 {
                self.setupProgress(progress: CGFloat(today)/CGFloat(level))
            } else {
                self.setupProgress(progress: 0)
            }
            
        }.disposed(by: cellDisposeBag)
        
        Observable.combineLatest(viewModel.isSuccess, viewModel.isReceive).bind {[weak self] (s, r) in
            guard let self = self else { return }
            if s > 0 {
                if r > 0 {
                    self.btn.setBackgroundImage(.create("diamond_img_btn3"), for: .normal)
                    self.btn.isUserInteractionEnabled = false
                } else {
                    self.btn.setBackgroundImage(.create("diamond_img_btn"), for: .normal)
                    self.btn.isUserInteractionEnabled = true
                }
            } else {
                self.btn.isUserInteractionEnabled = false
                self.btn.setBackgroundImage(.create("diamond_img_btn2"), for: .normal)
            }
        }.disposed(by: cellDisposeBag)
        
        btn.rx.tap.bind { _ in
            viewModel.openRedBag.onNext(viewModel)
        }.disposed(by: cellDisposeBag)
        
    }

}
