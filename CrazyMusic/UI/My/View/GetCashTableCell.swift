//
//  GetCashTableCell.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GetCashTableCell: TableViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#000000")
        lbl.font = .init(style: .regular, size: 15.uiX)
        lbl.text = "微信账户提现"
        return lbl
    }()
    
    lazy var timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#999999")
        lbl.font = .init(style: .regular, size: 12.uiX)
        return lbl
    }()
    
    lazy var cashLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#000000")
        lbl.font = .init(style: .medium, size: 15.uiX)
        return lbl
    }()
    
    lazy var statusLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#02B449")
        lbl.font = .init(style: .medium, size: 12.uiX)
        return lbl
    }()
    
    let avatarImgView = UIImageView()
    let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(avatarImgView)
        avatarImgView.cornerRadius = 11.uiX
        avatarImgView.snp.makeConstraints { make in
            make.width.equalTo(22.uiX)
            make.height.equalTo(22.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.top.equalToSuperview().offset(14.uiX)
        }
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImgView)
            make.left.equalTo(avatarImgView.snp.right).offset(9.5.uiX)
        }
        
        contentView.addSubview(timeLbl)
        timeLbl.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImgView)
            make.right.equalToSuperview().offset(-15.uiX)
        }
        
        contentView.addSubview(cashLbl)
        cashLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.bottom.equalToSuperview().offset(-5.uiX)
        }
        
        contentView.addSubview(statusLbl)
        statusLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalTo(cashLbl)
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
    
    func bind(to viewModel: CashRecordListModel) {
        let u = UserManager.shared.login.value.0
        avatarImgView.kf.setImage(with: URL(string: u?.avatar ?? ""))
        timeLbl.text = viewModel.createdAt
        cashLbl.attributedText = getCashStr(num: viewModel.cash)
        switch viewModel.paymentStatus {
        case 2:
            statusLbl.text = "付款失败"
            statusLbl.textColor = .init(hex: "#F96151")
        case 1:
            statusLbl.text = "已到账"
            statusLbl.textColor = .init(hex: "#999999")
        default:
            statusLbl.text = "等待到账"
            statusLbl.textColor = .init(hex: "#02B449")
        }
        
    }
    
    private func getCashStr(num: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .bold, size: 13.5.uiX),
            .foregroundColor: UIColor(hex: "#F96151")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 25.uiX)!,
            .foregroundColor: UIColor(hex: "#F96151")
        ]
        let s = NSMutableAttributedString(string: "元", attributes: a1)
        let s2 = NSMutableAttributedString(string: String(format: "%.2f", Float(num)/10000), attributes: a2)
        s2.append(s)
        return s2
    }
    
}
