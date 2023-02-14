//
//  GetCashViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import YYText

protocol GetCashViewControllerDelegate: AnyObject {
    
    func cashSelectedProtocol(controller: GetCashViewController)
    func cashSelectedRecord(controller: GetCashViewController)
    func cashSelectedPlayMusic(controller: GetCashViewController)
    func cashSelectedGetCash(controller: GetCashViewController)
}

class GetCashViewController: ViewController {
    
    var viewModel: CashViewModel!
    
    weak var delegate: GetCashViewControllerDelegate?
    
    var tableView: UITableView!
    
    var currentLevel = 0
    
    private var lbl1: UILabel!
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private var items = [ConfigurePriceModel]()
    
    private var playDisposeBag = DisposeBag()
    
    private var currentIndex = 0
    private let priceView = GetCashPriceSubView()

    private let cardView = GetCashCardSubView()
    private var isSelectedProtocol = true
    
    private let titleView2 = GetCashHeaderSubView()
    
    private let cashPublisher = PublishSubject<Int>()
    
    private let moneyCardView = GetCashMoneySubView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "提现"
        view.backgroundColor = .init(hex: "#FFFFFF")
        
        hbd_titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(style: .medium, size: 18),
            NSAttributedString.Key.foregroundColor : UIColor(hex: "#ffffff")
        ]
        
        hbd_barTintColor = .init(hex: "#FE5A2E")
        setupUI()
        setupBinding()
    }
    
    // MARK: - Event
    
    private func showLotteryView() {
        let pop = LotteryPopView(type: 1)
        pop.cashNext = { [weak self] in
            guard let self = self else { return }
            self.delegate?.cashSelectedPlayMusic(controller: self)
        }
        pop.coinNext = { [weak self] in
            guard let self = self else { return }
            self.delegate?.cashSelectedPlayMusic(controller: self)
        }
        PopView.show(view: pop)
    }
    
    private func onClickGetCash() {
        
        if !priceView.isAgreeProtocol {
            Observable.just("请先阅读并同意结算协议").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }
        if currentIndex >= items.count {
            return
        }
        let item = items[currentIndex]
        
        let cash = UserManager.shared.user?.cash ?? 0
        if cash < item.cash {
            PopView.show(view: GetCashInfoView())
            return
        }
        
        let level = currentLevel - 1
        if level < item.level {
            PopView.show(view: GetCashLevelView(num: item.level))
            return
        }

        cashPublisher.onNext(item.cash)
    
    }
    
    private func onClickGetCash(_ cash: Int) {
        
        if !priceView.isAgreeProtocol {
            Observable.just("请先阅读并同意结算协议").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }
        
        let totalCash = UserManager.shared.user?.cash ?? 0
        if totalCash < cash {
            PopView.show(view: GetCashInfoView())
            return
        }

        cashPublisher.onNext(cash)
    
    }
    
    // MARK: - UI
    
    func setupUI() {
        
        let backBtn = MusicButton()
        backBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        backBtn.setImage(UIImage(named: "icon_return"), for: .normal)
        backBtn.frame = .init(x: 0, y: 0, width: 40, height: 40)
        backBtn.contentHorizontalAlignment = .left
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        let rightBtn = MusicButton()
        rightBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            MobClick.event("me_cash_records")
            self.delegate?.cashSelectedRecord(controller: self)
        }).disposed(by: rx.disposeBag)
        rightBtn.setTitle("提现记录", for: .normal)
        rightBtn.setTitleColor(.init(hex: "#FEF6F6"), for: .normal)
        rightBtn.titleLabel?.font = .init(style: .regular, size: 15)
        rightBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        contentView.backgroundColor = .white
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(960.uiX)
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let header = titleView2
        contentView.addSubview(header)
        header.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(116.uiX)
        }
        
        contentView.addSubview(moneyCardView)
        moneyCardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
            make.height.equalTo(238.uiX)
        }
        
        let dlbl = UILabel()
        dlbl.font = .init(style: .medium, size: 16.uiX)
        dlbl.textColor = .init(hex: "#333333")
        dlbl.text = "微信提现"
        contentView.addSubview(dlbl)
        dlbl.snp.makeConstraints { make in
            make.top.equalTo(moneyCardView.snp.bottom)
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.equalTo(dlbl.snp.bottom).offset(10.uiX)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.uiX)
        }
        
        contentView.addSubview(priceView)
        priceView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.height.equalTo(250.uiX)
        }
        
        let infoView = GetCashInfoSubView()
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(priceView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
    }
    
    private func reloadUI() {
        if currentIndex >= items.count {
            return
        }
        var n = items.count / 2
        if items.count % 2 != 0 {
            n += 1
        }
        let height = 56.uiX * CGFloat(n) + 144.uiX
        contentView.snp.updateConstraints { make in
            make.height.equalTo(700.uiX + height)
        }
        priceView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        reloadUIWhenSlected()
    }
    
    private func reloadUIWhenSlected() {

    }
    
    private func getCashStr(num: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .bold, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 33.uiX)!,
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let s = NSAttributedString(string: "元", attributes: a1)
        let s2 = NSMutableAttributedString(string: String(format: "%.2f", Float(num)/10000), attributes: a2)
        s2.append(s)
        return s2
    }
    
    private func getCashLevelStr(num: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#4D4D4D")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FF5222")
        ]
        let s = NSMutableAttributedString(string: "距离下次提现机会，还差", attributes: a1)
        let s2 = NSAttributedString(string: " \(num) ", attributes: a2)
        let s3 = NSAttributedString(string: "关", attributes: a1)
        s.append(s2)
        s.append(s3)
        return s
    }
    
    private func getCoinStr(num: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .bold, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 33.uiX)!,
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let s = NSAttributedString(string: "个", attributes: a1)
        let s2 = NSMutableAttributedString(string: "\(num)", attributes: a2)
        s2.append(s)
        return s2
    }
    
    private func getCoinRedBagStr(num: Int, totoal:Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#4D4D4D")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FF5222")
        ]
        let s = NSMutableAttributedString(string: "今日已开", attributes: a1)
        let s2 = NSAttributedString(string: "\(num)/\(totoal)", attributes: a2)
        let s3 = NSAttributedString(string: "个红包", attributes: a1)
        s.append(s2)
        s.append(s3)
        return s
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        viewModel.controller = self
        
        var timeDisposeBag = DisposeBag()
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let u = u else { return }
            
            if u.isWithdraw {
                self.moneyCardView.cashCard.textLbl.attributedText = self.getCashStr(num: (u.cash ?? 0))
                self.moneyCardView.cashCard.levelLbl.attributedText = self.getCashLevelStr(num: u.withdrawLevel ?? 0)
                let total = u.withdrawLevelAll ?? 0
                let dif = total - (u.withdrawLevel ?? 0)
                self.moneyCardView.cashCard.setup(progress: dif >= 0 ? CGFloat(dif)/CGFloat(total) : 0)
                self.moneyCardView.cashCard.setupGetCash(enable: true)
            } else {
                self.moneyCardView.cashCard.textLbl.attributedText = self.getCashStr(num: (u.cash ?? 0))
                self.moneyCardView.cashCard.levelLbl.attributedText = self.getCashLevelStr(num: u.withdrawLevelReal ?? 0)
                let total = u.withdrawLevelAllReal ?? 0
                let dif = total - (u.withdrawLevelReal ?? 0)
                self.moneyCardView.cashCard.setup(progress: dif >= 0 ? CGFloat(dif)/CGFloat(total) : 0)
                self.moneyCardView.cashCard.setupGetCash(enable: false)
            }
            
            let totalConvert = UserManager.shared.configure?.songAd.convertMax ?? 0
            let currentConvert = u.convert ?? 0
            self.moneyCardView.coinCard.textLbl.attributedText = self.getCoinStr(num: (u.gold ?? 0))
            self.moneyCardView.coinCard.levelLbl.attributedText = self.getCoinRedBagStr(num: currentConvert, totoal: totalConvert)
            self.moneyCardView.coinCard.setup(progress: totalConvert > 0 ? CGFloat(currentConvert)/CGFloat(totalConvert) : 0)
            
            if u.isWeixin > 0 {
                self.titleView2.isUserInteractionEnabled = false
                self.titleView2.titleLbl.text = u.nickname
                self.titleView2.imgView.kf.setImage(with: URL(string: u.avatar ?? ""))
                self.titleView2.arrowImgView.isHidden = true
            }
            
            timeDisposeBag = DisposeBag()
            
            if u.withdrawChance {
                u.withdrawExpirationTime.subscribe(onNext: {[weak self] time in
                    guard let self = self else { return }
                    self.cardView.setup(cash: u.withdrawCash, time: time)
                }).disposed(by: timeDisposeBag)
                self.cardView.snp.updateConstraints { make in
                    make.height.equalTo(101.uiX)
                }
            } else {
                self.cardView.snp.updateConstraints { make in
                    make.height.equalTo(0.uiX)
                }
            }
           
        }).disposed(by: rx.disposeBag)
        
        let input = CashViewModel.Input(request: errorBtnTap.asObservable().startWith(()),
                                        cash: cashPublisher.asObserver(),
                                        requestWeChat: titleView2.btn.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: priceView.collectionView.rx.items(cellIdentifier: PayListCell.reuseIdentifier, cellType: PayListCell.self)) { [weak self] (row, element, cell) in
            guard let self = self else { return }
            if self.currentIndex == row {
                cell.bgView.borderColor = .init(hex: "#FF7B2E")
                cell.bgView.borderWidth = 1.uiX
                cell.bgView.backgroundColor = .init(hex: "#FEF7E8")
                cell.chooseImgView.isHidden = false
            } else {
                cell.bgView.borderColor = .init(hex: "#EBE8E1")
                cell.bgView.borderWidth = 1.uiX
                cell.bgView.backgroundColor = .white
                cell.chooseImgView.isHidden = true
            }
            cell.bind(to: element, isShowFinger: false)
        }.disposed(by: rx.disposeBag)
        
        output.items.bind {[weak self] items in
            guard let self = self else { return }
            self.items = items
            self.reloadUI()
        }.disposed(by: rx.disposeBag)
        
        output.success.subscribe(onNext: {[weak self] (gM, m) in
            guard let self = self else { return }
            guard let gM = gM else {
                Observable.just("请求数据为空").bind(to: self.view.rx.toastText()).disposed(by: self.rx.disposeBag)
                return
            }
            if gM.type == 1 {
                PopView.show(view: GetCashPopView(cash: m))
            } else {
                Observable.just(gM.msg ?? "申请成功，将于3日内审核到帐").bind(to: self.view.rx.toastText()).disposed(by: self.rx.disposeBag)
            }
        }).disposed(by: rx.disposeBag)
        
        priceView.collectionView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.currentIndex = index.row
            if index.row < self.items.count {
                let item = self.items[index.row]
                MobClick.event("me_cash_money", attributes: [
                    "cash": item.cash.cashDigits
                ])
            }
            self.priceView.collectionView.reloadData()
            self.reloadUIWhenSlected()
        }).disposed(by: rx.disposeBag)
        
        priceView.protocolAction = { [weak self] in
            guard let self = self else { return }
            self.delegate?.cashSelectedProtocol(controller: self)
        }
        priceView.cashAction = { [weak self] in
            guard let self = self else { return }
            MobClick.event("me_cash_conventional")
            self.onClickGetCash()
        }
        cardView.btn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let u = UserManager.shared.user else { return }
            self.onClickGetCash(u.withdrawCash)
        }).disposed(by: rx.disposeBag)
        
        moneyCardView.cashCard.btn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            MobClick.event("me_middleCash")
            self.showLotteryView()
        }).disposed(by: rx.disposeBag)

        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView()).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
    }
    

}
