//
//  SignPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import KTCenterFlowLayout
import RxDataSources

class SignPopView: UIView {
    
    let viewModel: SignViewModel
    private let rewardAd: RewardVideoAd
    
    private lazy var collectionView: UICollectionView = {
        let layout = KTCenterFlowLayout()
        layout.estimatedItemSize = .init(width: 100.uiX, height: 100.uiX)
//        layout.itemSize =
        layout.minimumLineSpacing = 10.uiX
        layout.minimumInteritemSpacing = 5.5.uiX
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(cellType: SignPopCell.self)
        collectionView.register(cellType: SignPopCell2.self)
        collectionView.register(cellType: SignPopCell3.self)
        
        return collectionView
    }()
    
    var cashAction: ((Bool)->())?
    
    init() {
        
        viewModel = SignViewModel()
        rewardAd = RewardVideoAd(slotId: "945408920", gdSlotId: "3011325865752897")
        
        let bgImg = UIImage.create("qdtx-bj")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)

        let titleLbl = UILabel()
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        titleLbl.font = .init(style: .medium, size: 18.uiX)
        titleLbl.height = 17.uiX
        titleLbl.width = width
        titleLbl.y = 35.uiX
        titleLbl.x = 0
        addSubview(titleLbl)
        
        let coinLbl = UILabel()
        coinLbl.textAlignment = .center
        coinLbl.width = width
        coinLbl.height = 26.uiX
        coinLbl.y = 67.5.uiX
        addSubview(coinLbl)
        
        let dayLbl = UILabel()
        dayLbl.textAlignment = .center
        dayLbl.width = width
        dayLbl.height = 13.5.uiX
        dayLbl.y = 169.5.uiX
        addSubview(dayLbl)
        
        let closeImg = UIImage.create("choose_icon_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 19.uiX
        closeBtn.x = width - closeBtn.width - 19.uiX
        addSubview(closeBtn)
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        let btnImg = UIImage.create("qdtx-fban")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 112.5.uiX
        btn.x = (width - btn.width)/2.0
        btn.isHidden = true
        addSubview(btn)
        
        collectionView.width = 300.uiX
        collectionView.height = 300.uiX
        collectionView.y = height - 15.5.uiX - collectionView.height
        collectionView.x = (width - collectionView.width)/2.0
        addSubview(collectionView)
        
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, _) in
            guard let self = self else { return }
            guard let u = u else { return }
            if u.isActive {
                if u.activeDouble > 0 {
                    titleLbl.y = 55.5.uiX
                    btn.isHidden = true
                    coinLbl.y = 97.5.uiX
                    titleLbl.text = "已翻\(u.activeDouble ?? 0)倍"
                    coinLbl.attributedText = self.getAttributedText(n: u.activeGold ?? 0)
                } else {
                    btn.isHidden = false
                    titleLbl.text = "签到成功"
                    coinLbl.attributedText = self.getAttributedText(n: u.activeGold ?? 0)
                }
            } else {
                btn.isHidden = true
                titleLbl.text = "正在签到"
            }
            dayLbl.attributedText = self.getDayAttributedText(n1: u.active ?? 0, n2: u.activeAll ?? 0)
        }).disposed(by: rx.disposeBag)
        
        let pub = PublishSubject<Void>()
        let doublePub = PublishSubject<Void>()
        let redBagPub = PublishSubject<SignListCellViewModel>()
        let input = SignViewModel.Input(request: pub.asObservable(), requestRedBag: redBagPub.asObserver(), requestDouble: doublePub.asObserver())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
            
            Observable.just("签到成功").bind(to: self.rx.toastText()).disposed(by: self.rx.disposeBag)
            
            if let m = m, let u = UserManager.shared.login.value.0 {
                u.gold += m.gold
                u.isActive = true
                u.activeGold = m.gold
                u.activeAll += 1
                u.active += 1
                UserManager.shared.login.accept((u, .change))
            }
        }).disposed(by: rx.disposeBag)
        
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController {
                self.rewardAd.showAd(vc: sup)
                self.rewardAd.completion = {
                    doublePub.onNext(())
                }
            }
        }).disposed(by: rx.disposeBag)
        
        output.doubleSuccess.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
            
            if let m = m, let u = UserManager.shared.login.value.0 {
                Observable.just("已翻\(m.doubleNum ?? 1)倍").bind(to: self.rx.toastText()).disposed(by: self.rx.disposeBag)
                u.gold += (m.doubleNum - 1) * m.gold
                u.activeGold = m.gold * m.doubleNum
                u.activeDouble = m.doubleNum
                UserManager.shared.login.accept((u, .change))
            }
            
        }).disposed(by: rx.disposeBag)
        
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, SignListCellViewModel>>(configureCell: { dataSource, collectionView, indexPath, item in
            
            if indexPath.row == 2 || indexPath.row == 5 {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SignPopCell2.self)
                cell.bind(to: item)
                return cell
            } else if indexPath.row == 6 {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SignPopCell3.self)
                cell.bind(to: item)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SignPopCell.self)
                cell.bind(to: item)
                return cell
            }
        })
        output.list.bind(to: collectionView.rx.items(dataSource: datasource)).disposed(by: rx.disposeBag)
        
        output.openRedBag.subscribe(onNext: {[weak self] vm in
            guard let self = self else { return }
            MobClick.event("sign_money", attributes: [
                "day": vm.day.value
            ])
            MobClick.event("video_signPacket_close")
            if let sup = self.parentViewController {
                self.rewardAd.showAd(vc: sup)
                self.rewardAd.completion = {
                    redBagPub.onNext(vm)
                }
            }
        }).disposed(by: rx.disposeBag)
        
        output.redBagSuccess.subscribe(onNext: { [weak self] m in
            guard let self = self else { return }
            if let m = m {
                Observable.just("领取到\(m.cash.cash)元红包").bind(to: self.rx.toastText()).disposed(by: self.rx.disposeBag)
            }
        }).disposed(by: rx.disposeBag)
        
        output.openCash.subscribe(onNext: {[weak self] vm in
            guard let self = self else { return }
            MobClick.event("sign_money7_Cash")
            if !vm.isWithdraw {
                if let sup = self.parentViewController as? PopView {
                    sup.hide()
                }
            }
            self.cashAction?(vm.isWithdraw)
            vm.isWithdraw = false
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
        if let u = UserManager.shared.login.value.0, !u.isActive {
            pub.onNext(())
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showMsg(msg: String) {
        if let view = UIApplication.shared.keyWindow {
            Observable.just(msg).bind(to: view.rx.toastText()).disposed(by: self.rx.disposeBag)
        }
    }
    
    deinit {
        
    }
    
    private func getAttributedText(n: Int) -> NSAttributedString {
        
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 30.uiX)!,
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        
        let a1 = NSMutableAttributedString(string: "+\(n)", attributes: att2)
        let a2 = NSMutableAttributedString(string: "金币", attributes: att1)
        a1.append(a2)
        return a1
    }
    
    private func getDayAttributedText(n1: Int, n2: Int) -> NSAttributedString {
        
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FFE03A")
        ]
        
        let a1 = NSMutableAttributedString(string: "已连续签到", attributes: att1)
        let a2 = NSAttributedString(string: "\(n1)", attributes: att2)
        let a3 = NSAttributedString(string: "天，累计共签到", attributes: att1)
        let a4 = NSAttributedString(string: "\(n2)", attributes: att2)
        let a5 = NSAttributedString(string: "天", attributes: att1)
        a1.append(a2)
        a1.append(a3)
        a1.append(a4)
        a1.append(a5)
        return a1
    }
    
}
