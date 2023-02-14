//
//  AwardRecordTableCell.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AwardRecordTableCell: TableViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#1A1A1A")
        lbl.font = .init(style: .regular, size: 15.uiX)
        return lbl
    }()
    
    lazy var timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#999999")
        lbl.font = .init(style: .regular, size: 12.uiX)
        return lbl
    }()
    
    lazy var numLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#000000")
        lbl.font = .init(style: .medium, size: 15.uiX)
        return lbl
    }()
    
    lazy var mark: UIView = {
        let lbl = MusicButton()
        lbl.setBackgroundImage(.create("diamond_record_img_label"), for: .normal)
        lbl.setTitle(" 双倍领取 ", for: .normal)
        lbl.setTitleColor(.white, for: .normal)
        lbl.titleLabel?.font = .init(style: .regular, size: 9.uiX)
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    let arrowImgView = UIImageView(image: UIImage(named: "diamond_icon_big"))
    let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.top.equalToSuperview().offset(14.uiX)
        }
        
        contentView.addSubview(mark)
        mark.snp.makeConstraints { make in
            make.left.equalTo(titleLbl.snp.right).offset(5.uiX)
            make.centerY.equalTo(titleLbl)
        }
        
        contentView.addSubview(timeLbl)
        timeLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.bottom.equalToSuperview().offset(-15.uiX)
        }
        
        contentView.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(arrowImgView.snp.size)
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(numLbl)
        numLbl.snp.makeConstraints { make in
            make.right.equalTo(arrowImgView.snp.left).offset(-5.uiX)
            make.centerY.equalToSuperview()
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
    
    // MARK: - Bind
    
    func bind(to viewModel: RewardRecordListModel) {
        titleLbl.text = viewModel.sourceType == 1 ? "闯关成功" : "今日签到"
        timeLbl.text = viewModel.createdAt
        numLbl.text = "+\(viewModel.gold ?? 0)"
        mark.isHidden = viewModel.isDouble > 0
    }
    
}
