//
//  LotteryPopView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import YYText

class LotteryPopView: UIView {
    
    var viewModel = LotteryViewModel()
    var cashNext: (()->())?
    var coinNext: (()->())?
    var laterGetCash: (()->())?
    var currentGetCash: (()->())?
    
    init(type: Int) {
        
        let bgImg = UIImage.create("qtx-cj-bg")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 50.uiX)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = .init(x: 0, y: 0, width: width, height: bgImg.snpSize.height)
        bgImgView.isUserInteractionEnabled = true
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFFFFF")
        titleLbl.font = .init(style: .regular, size: 13.uiX)
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 40.uiX
        titleLbl.y = 10.uiX + bgImgView.frame.maxY
        titleLbl.numberOfLines = 0
        titleLbl.numberOfLines = 0
        addSubview(titleLbl)
        
        let requestLottery = PublishSubject<Void>()
        let input = LotteryViewModel.Input(request: Observable<Int>.just(type), requestLottery: requestLottery.asObserver())
        let output = viewModel.transform(input: input)
        
        output.listFailure.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            Observable.just(0).delay(.seconds(2), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                if let sup = self.parentViewController as? PopView {
                    sup.hide()
                }
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        var currentItem: LotteryItemView!
        var lotteryItems = [LotteryItemView]()
        
        output.success.subscribe(onNext: {[weak self] model in
            guard let self = self else { return }
            let playBtn = LotteryPlayView()
            
            let startX = 30.uiX
            var x = startX
            var y = 38.uiX
            let m = -9.uiX
            for i in 1...9 {
                if i != 5 {
                    let item1 = LotteryItemView()
                    item1.x = x
                    item1.y = y
                    bgImgView.addSubview(item1)
                    if i % 3 == 0 {
                        y = item1.frame.maxY + m
                        x = startX
                    } else {
                        x = item1.frame.maxX + m
                    }
                    lotteryItems.append(item1)
                } else {
                    playBtn.x = x
                    playBtn.y = y
                    if i % 3 == 0 {
                        y = playBtn.frame.maxY + m
                        x = startX
                    } else {
                        x = playBtn.frame.maxX + m
                    }
                    bgImgView.addSubview(playBtn)
                }
            }
            
            lotteryItems[0].setup(model: .init(type: 2, cash: model.items[0]))
            lotteryItems[1].setup(model: .init(type: 3, cash: 0))
            lotteryItems[2].setup(model: .init(type: 2, cash: model.items[1]))
            lotteryItems[3].setup(model: .init(type: 1, cash: 0))
            lotteryItems[4].setup(model: .init(type: 1, cash: 0))
            lotteryItems[5].setup(model: .init(type: 2, cash: model.items[2]))
            lotteryItems[6].setup(model: .init(type: 3, cash: 0))
            lotteryItems[7].setup(model: .init(type: 2, cash: model.items[3]))
            
            lotteryItems[0].nextItem = lotteryItems[1]
            lotteryItems[1].nextItem = lotteryItems[2]
            lotteryItems[2].nextItem = lotteryItems[4]
            lotteryItems[4].nextItem = lotteryItems[7]
            lotteryItems[7].nextItem = lotteryItems[6]
            lotteryItems[6].nextItem = lotteryItems[5]
            lotteryItems[5].nextItem = lotteryItems[3]
            lotteryItems[3].nextItem = lotteryItems[0]
            
            playBtn.playBtn.rx.tap.subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.isUserInteractionEnabled = false
                MobClick.event("cash_opportunity")
                currentItem = lotteryItems[0]
                currentItem.isSelected = true
                requestLottery.onNext(())
            }).disposed(by: self.rx.disposeBag)
            
            var time = model.time ?? 0
            titleLbl.attributedText = self.getAttributedText(n: time)
            Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] t in
                guard let self = self else { return }
                time -= 1
                if time <= 0 {
                    if let sup = self.parentViewController as? PopView {
                        sup.hide()
                    }
                    return
                }
                titleLbl.attributedText = self.getAttributedText(n: time)
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        output.step.subscribe(onNext: { _ in
            currentItem.isSelected = false
            if let n = currentItem.nextItem {
                currentItem = n
                currentItem.isSelected = true
            }
        }).disposed(by: rx.disposeBag)
        
        let secondTime = Int.random(in: 1000...4000)
        var lotteryDisposeBag = DisposeBag()
        output.lotteryFinished.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
            guard let m = m else { return }
            var rightItem: LotteryItemView!
            switch m.type {
            case 1:
                let idx = Int.random(in: 0...1)
                rightItem = [lotteryItems[3], lotteryItems[4]][idx]
            case 2:
                let ite = [lotteryItems[0], lotteryItems[2], lotteryItems[5], lotteryItems[7]].filter{ $0.model.cash == m.num }.first
                rightItem = ite ?? lotteryItems[0]
            default:
                let idx = Int.random(in: 0...1)
                rightItem = [lotteryItems[1], lotteryItems[6]][idx]
            }
            lotteryDisposeBag = DisposeBag()
            Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] i in
                guard let self = self else { return }
                if secondTime < i * 500 && currentItem == rightItem {
                    Observable.just(1).delay(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
                        guard let self = self else { return }
                        switch m.type {
                        case 1:
                            let lo = LotteryGetCashView(cash: m.num)
                            lo.action = self.currentGetCash
                            lo.laterAction = self.laterGetCash
                            PopView.show(view: lo)
                        case 2:
                            let lo = LotteryCashView(cash: m.num)
                            lo.action = self.cashNext
                            PopView.show(view: lo)
                        default:
                            let lo = LotteryCoinView(coin: m.num)
                            lo.action = self.coinNext
                            PopView.show(view: lo)
                        }
                    }).disposed(by: self.rx.disposeBag)
                    lotteryDisposeBag = DisposeBag()
                    return
                }
                currentItem.isSelected = false
                if let n = currentItem.nextItem {
                    currentItem = n
                    currentItem.isSelected = true
                }
            }).disposed(by: lotteryDisposeBag)
        }).disposed(by: rx.disposeBag)
        output.lotteryError.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.isUserInteractionEnabled = true
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getAttributedText(n: Int) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FFF25C")
        ]
        
        let a1 = NSMutableAttributedString(string: "每次提现机会，均可随机抽取一次提现金额\n本次提现机会即将失效，剩余", attributes: att1)
        let m = n / 60
        let s = n % 60
        let a2 = NSAttributedString(string: String(format: "%.2d:%.2d", m, s), attributes: att2)
        a1.append(a2)
        return a1
    }
    
    deinit {
        print("\(self)")
    }
    
}

private class LotteryItemView: UIView {
    
    struct LotteryItemModel {
        let type: Int
        let cash: Int
    }
    
    var fImgView: UIImageView!
    var bgImgView: UIImageView!
    var nextItem: LotteryItemView?
    private let lbl1 = UILabel()
    private let lbl2 = UILabel()
    var model: LotteryItemModel!
    
    var isSelected: Bool {
        set {
            bgImgView.isHidden = !newValue
            fImgView.isHidden = newValue
        }
        
        get {
            return !bgImgView.isHidden
        }
    }
    
    init() {
        
        let bgImg = UIImage.create("qtx-cj-xzk")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let imgF = UIImage.create("qtx-cj-k")
        fImgView = UIImageView(image: imgF)
        fImgView.size = imgF.snpSize
        fImgView.center = center
        addSubview(fImgView)
        
        isSelected = false
        
        lbl1.font = .init(style: .regular, size: 14.uiX)
        lbl1.textColor = .init(hex: "#4B1592")
        
        lbl2.font = .init(style: .medium, size: 19.uiX)
        lbl2.textColor = .init(hex: "#E34657")
        
        let s = UIStackView(arrangedSubviews: [lbl1, lbl2], axis: .vertical)
        s.alignment = .center
        s.spacing = 6.5.uiX
        addSubview(s)
        s.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setup(model: LotteryItemModel) {
        self.model = model
        switch model.type {
        case 1:
            lbl1.text = "提现"
            lbl2.text = "???元"
        case 2:
            lbl1.text = "提现"
            lbl2.text = "\(model.cash.cash)元"
        default:
            lbl1.textColor = .init(hex: "#E34657")
            lbl1.font = .init(style: .regular, size: 14.uiX)
            lbl1.text = "现金/金币"
            lbl2.textColor = .init(hex: "#E34657")
            lbl2.font = .init(style: .regular, size: 14.uiX)
            lbl2.text = "礼包"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class LotteryPlayView: UIView {
    
    let playBtn = MusicButton()
    
    init() {
        
        let bgImg = UIImage.create("qtx-cj-xzk")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        
        let imgF = UIImage.create("qtx-cj-djcj")
        let fImgView = UIImageView(image: imgF)
        fImgView.size = imgF.snpSize
        fImgView.center = center
        addSubview(fImgView)
        
        playBtn.frame = bounds
        addSubview(playBtn)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
