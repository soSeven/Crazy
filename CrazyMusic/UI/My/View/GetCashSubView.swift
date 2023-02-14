//
//  GetCashSubView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/16.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import YYText
import RxCocoa
import RxSwift

class GetCashHeaderSubView: UIView {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .medium, size: 17.uiX)
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.text = "绑定微信"
        return lbl
    }()
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 14.uiX)
        lbl.textColor = .init(hex: "#FFEED3")
        lbl.text = "可提现金额(元)"
        return lbl
    }()
    
    lazy var imgView: UIImageView = {
        return UIImageView(image: .create("tx-mrtx"))
    }()
    
    lazy var arrowImgView: UIImageView = {
        return UIImageView(image: UIImage.create("tx-bd-icon"))
    }()
    
    let btn = MusicButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .init(hex: "#FE5A2E")
        
        let s = UIStackView(arrangedSubviews: [titleLbl, textLbl], axis: .vertical)
        s.alignment = .leading
        s.spacing = 4.uiX
        
        let alertView = GetCashAlertSubView()
        
        addSubview(s)
        addSubview(alertView)
        addSubview(imgView)
        addSubview(btn)
        addSubview(arrowImgView)
        
        alertView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(33.uiX)
        }
        
        s.snp.makeConstraints { make in
            make.centerY.equalTo(imgView.snp.centerY)
            make.left.equalTo(imgView.snp.right).offset(12.uiX)
        }
        
        arrowImgView.snp.makeConstraints { make in
            make.centerY.equalTo(imgView.snp.centerY)
            make.right.equalToSuperview().offset(-14.uiX)
            make.size.equalTo(arrowImgView.image!.snpSize)
        }
        
        imgView.contentMode = .scaleAspectFill
        imgView.cornerRadius = 27.uiX
        imgView.borderColor = .white
        imgView.borderWidth = 1.5.uiX
        imgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.width.equalTo(54.uiX)
            make.height.equalTo(54.uiX)
        }
        
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GetCashInfoSubView: UIView {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 15.uiX)
        lbl.textColor = .init(hex: "#333333")
        lbl.text = "提现说明"
        return lbl
    }()
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        let text =
        """
        1.由于微信支付需要实名制，非实名用户账户无法支持提现，请务必将提现的微信号进行实名认证。
        2.提现申请将在3个工作日内审核，审核通过即可到账请耐心等待。
        3.每日只可申请提现一次，再次提现请于次日申请。
        4.新人专享福利每个账号仅可享受一次。
        5.更多提现详情请见《用户协议》。
        """
        let p = NSMutableParagraphStyle()
        p.lineSpacing = 4.uiX
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#808080"),
            .paragraphStyle: p
        ]
        lbl.attributedText = .init(string: text, attributes: att)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLbl)
        addSubview(textLbl)
        
        titleLbl.snp.makeConstraints { make in
            make.top.right.equalToSuperview().offset(23.uiX)
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        textLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(12.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.bottom.equalToSuperview().offset(-15.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GetCashAlertSubView: UIView {
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 12.uiX)
        lbl.textColor = .init(hex: "#FDE2B7")
        lbl.text = "微信收款账户一经绑定无法更改，以后都将提现至此账号。"
        return lbl
    }()
    
    lazy var imgView: UIImageView = {
        let i = UIImageView()
        i.image = .create("tx-ts-icon")
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#BC340F").alpha(0.16)
        
        let s = UIStackView(arrangedSubviews: [imgView, textLbl], axis: .horizontal)
        s.alignment = .center
        s.spacing = 4.uiX
        addSubview(s)
        
        s.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        imgView.snp.makeConstraints { make in
            make.width.equalTo(13.uiX)
            make.height.equalTo(13.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GetCashCardSubView: UIView {
    
//    lazy var textLbl2: UILabel = {
//        let lbl = UILabel()
//        lbl.font = .init(style: .regular, size: 14.uiX)
//        lbl.textColor = .init(hex: "#F34A4A")
//        return lbl
//    }()
//
//    lazy var textLbl3: UILabel = {
//        let lbl = UILabel()
//        lbl.font = .init(style: .regular, size: 14.uiX)
//        lbl.textColor = .init(hex: "#FFFFFF")
//        return lbl
//    }()
    
    let btn = MusicButton()
    let contentView = UIView()
    let pricelbl = UILabel()
    let timeLbl = UILabel()
    
    private let bgImgView = UIImageView()
    private let lbl1 = UILabel()
    private let lbl2 = UILabel()
    private let lbl3 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImg = UIImage.create("tx-xstx-bj")
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(bgImg.snpSize)
            make.centerX.equalToSuperview()
        }
        
        bgImgView.image = bgImg
        contentView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pricelbl.font = .init(style: .regular, size: 14.uiX)
        pricelbl.textColor = .init(hex: "#FF4444")

        lbl1.font = .init(style: .regular, size: 13.uiX)
        lbl1.textColor = .init(hex: "#874813")
        lbl1.text = "可提现"

        let s1 = UIStackView()
        s1.axis = .vertical
        s1.spacing = 5.uiX
        s1.alignment = .center
        s1.addArrangedSubviews([pricelbl, lbl1])
        contentView.addSubview(s1)
        s1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14.uiX)
            make.centerY.equalToSuperview()
        }

        lbl2.font = .init(style: .medium, size: 15.uiX)
        lbl2.textColor = .init(hex: "#703A0D")
        lbl2.text = "限时提现机会"

        lbl3.font = .init(style: .regular, size: 12.uiX)
        lbl3.textColor = .init(hex: "#8F6D4F")
        lbl3.text = "请在有效时间内提现"

        let s2 = UIStackView()
        s2.axis = .vertical
        s2.spacing = 5.uiX
        s2.alignment = .leading
        s2.addArrangedSubviews([lbl2, lbl3])
        contentView.addSubview(s2)
        s2.snp.makeConstraints { make in
            make.left.equalTo(s1.snp.right).offset(19.5.uiX)
            make.centerY.equalToSuperview()
        }

        timeLbl.font = .init(style: .medium, size: 14.uiX)
        timeLbl.textColor = .init(hex: "#BB5D0F")
        timeLbl.text = "00:00:00"

        let btnImg = UIImage.create("tx-xstx-an")
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.snp.makeConstraints { make in
            make.size.equalTo(btnImg.snpSize)
        }
        
        let s3 = UIStackView()
        s3.axis = .vertical
        s3.spacing = 5.uiX
        s3.alignment = .center
        s3.addArrangedSubviews([timeLbl, btn])
        contentView.addSubview(s3)
        s3.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10.5.uiX)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(cash: Int, time: Int) {
        
        let h = time / 60 / 60
        let m = (time - (h * 60 * 60)) / 60
        let s = (time - (h * 60 * 60)) % 60
        
        timeLbl.text = String(format: "%.2d:%.2d:%.2d", h, m, s)
        
        if time > 0 {
            bgImgView.image = UIImage.create("tx-xstx-bj")
            lbl1.textColor = .init(hex: "#874813")
            lbl2.textColor = .init(hex: "#703A0D")
            lbl3.textColor = .init(hex: "#8F6D4F")
            timeLbl.textColor = .init(hex: "#BB5D0F")
            let btnImg = UIImage.create("tx-xstx-an")
            btn.setBackgroundImage(btnImg, for: .normal)
            btn.isUserInteractionEnabled = true
        } else {
            bgImgView.image = UIImage.create("tx-xstx-ygq-bg")
            lbl1.textColor = .init(hex: "#9C9C9C")
            lbl2.textColor = .init(hex: "#7F7F7F")
            lbl3.textColor = .init(hex: "#9C9C9C")
            timeLbl.textColor = .init(hex: "#7F7F7F")
            let btnImg = UIImage.create("tx-ygq-an")
            btn.setBackgroundImage(btnImg, for: .normal)
            btn.isUserInteractionEnabled = false
        }
        pricelbl.attributedText = getTimeCashStr(num: cash, enable: time > 0)
    }
    
    private func getTimeCashStr(num: Int, enable: Bool) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .bold, size: 13.uiX),
            .foregroundColor: UIColor(hex: enable ? "#FF4444" : "#656565")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 32.uiX)!,
            .foregroundColor: UIColor(hex: enable ? "#FF4444" : "#656565")
        ]
        let s = NSAttributedString(string: "元", attributes: a1)
        let s2 = NSMutableAttributedString(string: num.cash, attributes: a2)
        s2.append(s)
        return s2
    }
}

class GetCashMoneySubView: UIView {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .medium, size: 16.uiX)
        lbl.textColor = .init(hex: "#333333")
        lbl.text = "我的钱包"
        return lbl
    }()
    
    let cashCard = GetCashMoneyItemSubView(type: .cash)
    let coinCard = GetCashMoneyItemSubView(type: .coin)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        addSubview(titleLbl)
        addSubview(scrollView)
        
        titleLbl.snp.makeConstraints { make in
            make.top.right.equalToSuperview().offset(13.uiX)
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLbl.snp.bottom).offset(10.uiX)
            make.height.equalTo(172.uiX)
        }
        
        scrollView.addSubview(cashCard)
        scrollView.addSubview(coinCard)
        
        cashCard.x = 15.uiX
        cashCard.y = 0
        cashCard.width = 301.5.uiX
        cashCard.height = 172.uiX
        
        coinCard.x = 15.uiX + cashCard.frame.maxX
        coinCard.y = 0
        coinCard.width = 301.5.uiX
        coinCard.height = 172.uiX
        
        scrollView.contentSize = .init(width: coinCard.frame.maxX + 15.uiX, height: cashCard.height)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GetCashMoneyItemSubView: UIView {
    
    enum MoneyItemType {
        case cash
        case coin
    }
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 13.uiX)
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.text = "可提现金额"
        return lbl
    }()
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    lazy var levelLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 13.uiX)
        lbl.textColor = .init(hex: "#4D4D4D")
        lbl.text = ""
        return lbl
    }()
    
    private var lightImgView: UIView?
    private var cashMarkImgView: UIView?
    private let progressView = UIView()
    let btn = UIButton()
    
    let type: MoneyItemType
    
    init(type: MoneyItemType) {
        
        self.type = type
        
        super.init(frame: .zero)
        
        let pBgView = UIView()
        pBgView.cornerRadius = 3.uiX
        pBgView.backgroundColor = .init(hex: "#FFC695")
        
        progressView.backgroundColor = .init(hex: "#FF491F")
        
        let imgView1 = UIImageView(image: .create(type == .cash ? "tx-wdqb-yebg" : "tx-jb-bg"))
        
        titleLbl.text = type == .cash ? "可提现金额" : "我的金币"
        
        addSubview(imgView1)
        addSubview(titleLbl)
        addSubview(textLbl)
        addSubview(levelLbl)
        addSubview(pBgView)
        
        pBgView.addSubview(progressView)
        
        imgView1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25.uiX)
        }
        
        textLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(45.uiX)
        }
        
        levelLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13.uiX)
            make.bottom.equalToSuperview().offset(-33.uiX)
        }
        
        pBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13.uiX)
            make.bottom.equalToSuperview().offset(-18.uiX)
            make.width.equalTo(260.uiX)
            make.height.equalTo(6.uiX)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0)
        }
        
        switch type {
        case .cash:
            
            let lightImgView = UIImageView(image: .create("tx-gx-icon"))
            addSubview(lightImgView)
            
            let redBagImgView = UIImageView(image: .create("tx-lh-icon"))
            addSubview(redBagImgView)
            
            let cashMarkImg = UIImage.create("tx-ktx-icon")
            let cashMarkImgView = UIButton()
            cashMarkImgView.setBackgroundImage(cashMarkImg, for: .normal)
            cashMarkImgView.titleLabel?.font = .init(style: .regular, size: 9.uiX)
            cashMarkImgView.setTitleColor(.white, for: .normal)
            cashMarkImgView.setTitle("可提现", for: .normal)
            cashMarkImgView.isUserInteractionEnabled = false
            addSubview(cashMarkImgView)
            
            redBagImgView.snp.makeConstraints { make in
                make.bottom.equalTo(pBgView.snp.bottom)
                make.centerX.equalTo(pBgView.snp.right)
                make.size.equalTo(redBagImgView.image!.snpSize)
            }
            
            redBagImgView.isUserInteractionEnabled = true
            redBagImgView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            cashMarkImgView.snp.makeConstraints { make in
                make.centerX.equalTo(redBagImgView)
                make.top.equalTo(redBagImgView.snp.bottom).offset(2.uiX)
            }
            
            lightImgView.snp.makeConstraints { make in
                make.size.equalTo(lightImgView.image!.snpSize)
                make.center.equalTo(redBagImgView)
            }
            
            lightImgView.isHidden = true
            cashMarkImgView.isHidden = true
            
            self.lightImgView = lightImgView
            self.cashMarkImgView = cashMarkImgView
            
        case .coin:
            let redBagImgView = UIImageView(image: .create("tx-jbye-hb-icon"))
            addSubview(redBagImgView)
            redBagImgView.snp.makeConstraints { make in
                make.bottom.equalTo(pBgView.snp.bottom)
                make.centerX.equalTo(pBgView.snp.right)
                make.size.equalTo(redBagImgView.image!.snpSize)
            }
            
            redBagImgView.isUserInteractionEnabled = true
            redBagImgView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        setupGetCash(enable: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(progress: CGFloat) {
        switch type {
        case .cash:
            progressView.snp.remakeConstraints { make in
                make.left.bottom.top.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(progress)
            }
            
        case .coin:
            progressView.snp.remakeConstraints { make in
                make.left.bottom.top.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(progress)
            }
        }
    }
    
    func setupGetCash(enable: Bool) {
        if enable {
            lightImgView?.isHidden = false
            cashMarkImgView?.isHidden = false
            lightImgView?.layer.removeAllAnimations()
            let ro = CABasicAnimation(keyPath: "transform.rotation.z")
            ro.toValue = Double.pi*2.0
            ro.duration = 5
            ro.repeatCount = HUGE
            ro.isRemovedOnCompletion = true
            ro.fillMode = .forwards
            lightImgView?.layer.add(ro, forKey: "rotationAnimation")
            btn.isUserInteractionEnabled = true
        } else {
            lightImgView?.isHidden = true
            cashMarkImgView?.isHidden = true
            lightImgView?.layer.removeAllAnimations()
            btn.isUserInteractionEnabled = false
        }
    }
    
    
}

class GetCashPriceSubView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 158.5.uiX, height: 50.5.uiX)
        layout.minimumLineSpacing = 5.5.uiX
        layout.minimumInteritemSpacing = 5.5.uiX
        layout.sectionInset = .init(top: 0, left: 9.5.uiX, bottom: 0, right: 9.5.uiX)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(cellType: PayListCell.self)
        
        return collectionView
    }()
    
    var isAgreeProtocol = true
    var protocolAction: (()->())?
    var cashAction: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .init(hex: "#FFF9F3")
        borderColor = .init(hex: "#FFE2C6")
        borderWidth = 1.uiX
        cornerRadius = 10.uiX
        
        let pBtn = MusicButton()
        pBtn.setImage(.create("withdraw_icon_choose_nor"), for: .normal)
        pBtn.setImage(.create("withdraw_icon_choose"), for: .selected)
        pBtn.isSelected = isAgreeProtocol
        pBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.isAgreeProtocol = !self.isAgreeProtocol
            pBtn.isSelected = self.isAgreeProtocol
        }).disposed(by: rx.disposeBag)
        
        let text = NSMutableAttributedString(string: "已阅读并同意")
        text.yy_font = .init(style: .regular, size: 14.uiX)
        text.yy_color = .init(hex: "#666666")
        let a = NSMutableAttributedString(string: "用户结算协议")
        a.yy_font = .init(style: .regular, size: 14.uiX)
        a.yy_color = .init(hex: "#277DFF")
        let hi = YYTextHighlight()
        hi.tapAction =  { [weak self] containerView, text, range, rect in
            guard let self = self else { return }
            self.protocolAction?()
        }
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        text.append(a)
        let protocolLbl = YYLabel()
        protocolLbl.attributedText = text
        
        addSubview(protocolLbl)
        addSubview(pBtn)
        protocolLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15.uiX)
        }
        
        pBtn.snp.makeConstraints { make in
            make.centerY.equalTo(protocolLbl)
            make.right.equalTo(protocolLbl.snp.left).offset(-6.uiX)
        }
        
        let btnImg = UIImage.create("tx-an-cgtx")
        let cashBtn = MusicButton()
        cashBtn.setBackgroundImage(btnImg, for: .normal)
        cashBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.cashAction?()
        }).disposed(by: rx.disposeBag)
        addSubview(cashBtn)
        cashBtn.snp.makeConstraints { make in
            make.bottom.equalTo(protocolLbl.snp.top).offset(-12.uiX)
            make.centerX.equalToSuperview()
            make.size.equalTo(btnImg.snpSize)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(19.uiX)
            make.bottom.equalTo(cashBtn.snp.top).offset(-30.uiX)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


