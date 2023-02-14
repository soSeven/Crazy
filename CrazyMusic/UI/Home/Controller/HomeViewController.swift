//
//  HomeViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/6.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie
import YYText

protocol HomeViewControllerDelegate: AnyObject {
    
    func homeDidSelectedCash(controller: HomeViewController, level: Int?)
    func homeDidSelectedMine(controller: HomeViewController)
    
}

class HomeViewController: ViewController {
    
    private let contentView = UIView()
    private let answerBgView = UIView()
    
    weak var delegate: HomeViewControllerDelegate?
    
    var viewModel: HomeViewModel!
    
    private let showErrorAnswer =  PublishRelay<Void>()
    private let requestNextMusic =  PublishRelay<(SongCellViewModel, Bool)>()
    
    private let waitView = UIView()
    private let redBagNumlbl = UILabel()
    
    private let countView = UIView()
    private let timeCountLbl = UILabel()
    private let progressView = UIView()
    
    private let resultStatuView = UIView()
    private let resultLbl = UILabel()
    private let resultImgView = UIImageView()
    
    var rightView: HomeRightView!
    private var leftView: HomeLeftView!
    
    private var levelLbl1: UILabel!
    private var levelLbl2: UILabel!
    
    private let avatarImgView = UIImageView()
    private let cashlbl = UILabel()
    private let diamondlbl = UILabel()
    private let lifeViewlbl = UILabel()
    private var lifeImgViews = [UIImageView]()
    private let fingerImgView = UIImageView()
    private let markGetCashView = UIImageView()
    private let levelToLevelbl = UILabel()
    private let goToCashLbl = YYLabel()
    private let markGetCashBtn = UIButton()
    private var markGetCashBtnDisposeBag = DisposeBag()
    
    private var hpTimeDisposeBag = DisposeBag()
    
    private var avatarSelecteView: UIView?
    
    var currentSong: SongModel?
    
    var isAppear = false
    
    private var rewardAd: RewardVideoAd!

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        setupUI()
        setupBinding()
        setupAd()
        sound()
        MusicPlayer.shared.currentViewControler = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAppear = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isAppear = false
    }
    
    private func setupAd() {
        rewardAd = RewardVideoAd(slotId: "945408915", gdSlotId: "2061527835665080", needLoad: true)
    }
    
    // MARK: - 抽奖
    
    private func showLotteryView(type: Int) {
        let pop = LotteryPopView(type: type)
        pop.currentGetCash = { [weak self] in
            guard let self = self else { return }
            self.delegate?.homeDidSelectedCash(controller: self, level: self.currentSong?.level)
        }
        PopView.show(view: pop)
    }
    
    // MARK: - 调节音乐
    
    private func sound() {
        let sound = SoundProgressView()
        sound.action = {
            if let u = UserManager.shared.user, u.isNew {
                PopView.show(view: NewUserPopView())
            }
        }
        PopView.show(view: sound)
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        UserManager.shared.login.subscribe(onNext: { (u, s) in
            guard let u = u else { return }
            self.avatarImgView.kf.setImage(with: URL(string: u.avatar ?? ""))
            let singleNum = u.singleNum ?? 0
            self.rightView.numlbl.text = "\(singleNum)"
            self.rightView.numlbl.isHidden = (singleNum == 0) ? true : false
            self.cashlbl.text = String(format: "%.2f元", Float(u.cash ?? 0)/10000)
            let gold = u.gold ?? 0
            self.diamondlbl.text = gold.price
            for (idx, view) in self.lifeImgViews.enumerated() {
                if idx + 1 <= u.hp {
                    view.image = .create("sy-tl-icon")
                } else {
                    view.image = .create("sy-wtl-icon")
                }
            }
            var time = 0
            if u.hpTime > 0 {
                time = u.hpTime
            } else if let n = UserManager.shared.configure?.hp.restoreTime, n > 0 {
                time = n
            }
            self.hpTimeDisposeBag = DisposeBag()
            if u.hp == 3 {
                self.lifeViewlbl.isHidden = true
            } else {
                self.lifeViewlbl.isHidden = false
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    time -= 1
                    let m = time / 60
                    let s = time % 60
                    self.lifeViewlbl.text = String(format: "%.2d:%.2d 后+1", m, s)
                    if time <= 0 {
                        u.hp += UserManager.shared.configure?.hp.restoreNum ?? 1
                        UserManager.shared.login.accept((u, .change))
                    }
                }).disposed(by: self.hpTimeDisposeBag)
            }
            
            let normalAtt: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor(hex: "#FFFFFF"),
                .font: UIFont(style: .regular, size: 11.uiX)
            ]
            let att: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor(hex: "#FFDE5D"),
                .font: UIFont(style: .regular, size: 11.uiX)
            ]
            
            self.markGetCashBtnDisposeBag = DisposeBag()
            
            var textAtt: NSMutableAttributedString!
            
            ///提现显示
            if u.isWithdraw {
                if !UserManager.shared.isCheck {
                    self.markGetCashView.isHidden = false
                    self.fingerImgView.isHidden = false
                    self.levelToLevelbl.isHidden = true
                }
                
                let a = NSMutableAttributedString(string: "已完成", attributes: normalAtt)
                let b = NSAttributedString(string: "\(u.withdrawLevelAll ?? 0)关", attributes: att)
                a.append(b)
                self.redBagNumlbl.attributedText = a
                self.progressView.width = 170.uiX
                
                textAtt = NSMutableAttributedString(string: "已完成")
                textAtt.yy_font = .init(style: .regular, size: 13.uiX)
                textAtt.yy_color = .init(hex: "#FFFFFF")
                let aAtt = NSMutableAttributedString(string: "\(u.withdrawLevelAll ?? 0)关")
                aAtt.yy_font = .init(style: .regular, size: 13.uiX)
                aAtt.yy_color = .init(hex: "#FFDE5E")
                let bAtt = NSMutableAttributedString(string: "，可以提现哦  ")
                bAtt.yy_font = .init(style: .regular, size: 13.uiX)
                bAtt.yy_color = .init(hex: "#FFFFFF")
                
                let cAtt = NSMutableAttributedString(string: "去提现>")
                cAtt.yy_font = .init(style: .regular, size: 13.uiX)
                cAtt.yy_color = .init(hex: "#FFDE5E")
                let hi = YYTextHighlight()
                hi.tapAction =  { [weak self] containerView, text, range, rect in
                    guard let self = self else { return }
                    MobClick.event("songs_bottomCash", attributes: [
                        "type" : "抽奖",
                    ])
                    self.showLotteryView(type: 1)
                }
                cAtt.yy_setTextHighlight(hi, range: cAtt.yy_rangeOfAll())
                
                textAtt.append(aAtt)
                textAtt.append(bAtt)
                textAtt.append(cAtt)
                
                self.markGetCashBtn.rx.tap.subscribe(onNext: {[weak self] _ in
                    guard let self = self else { return }
                    MobClick.event("songs_middleCash")
                    self.showLotteryView(type: 1)
                }).disposed(by: self.markGetCashBtnDisposeBag)
                
            } else {
                if !UserManager.shared.isCheck {
                    self.markGetCashView.isHidden = true
                    self.fingerImgView.isHidden = true
                    self.levelToLevelbl.isHidden = false
                }
                let a = NSMutableAttributedString(string: "通过", attributes: normalAtt)
                let b = NSAttributedString(string: "\(u.withdrawLevelReal ?? 0)关 ", attributes: att)
                let c = NSAttributedString(string: "可以提现", attributes: att)
                a.append(b)
                a.append(c)
                self.redBagNumlbl.attributedText = a
                let total = u.withdrawLevelAllReal ?? 0
                let dif = total - (u.withdrawLevelReal ?? 0)
                if total > 0 {
                    self.progressView.width = CGFloat(dif) / CGFloat(total) * 170.uiX
                } else {
                    self.progressView.width = 0
                }
                let mA = NSMutableAttributedString(string: "\(dif)")
                mA.yy_font = .init(style: .regular, size: 9.uiX)
                mA.yy_color = .init(hex: "#FFE248")
                let mB = NSMutableAttributedString(string: "/\(total)")
                mB.yy_font = .init(style: .regular, size: 9.uiX)
                mB.yy_color = .init(hex: "#FFFFFF")
                mA.append(mB)
                self.levelToLevelbl.attributedText = mA
                
                textAtt = NSMutableAttributedString(string: "继续通关~再过")
                textAtt.yy_font = .init(style: .regular, size: 13.uiX)
                textAtt.yy_color = .init(hex: "#FFFFFF")
                let aAtt = NSMutableAttributedString(string: "\(u.withdrawLevelReal ?? 0)关")
                aAtt.yy_font = .init(style: .regular, size: 13.uiX)
                aAtt.yy_color = .init(hex: "#FFDE5E")
                let bAtt = NSMutableAttributedString(string: "就可以提现哦  ")
                bAtt.yy_font = .init(style: .regular, size: 13.uiX)
                bAtt.yy_color = .init(hex: "#FFFFFF")
                
                let cAtt = NSMutableAttributedString(string: "去提现>")
                cAtt.yy_font = .init(style: .regular, size: 13.uiX)
                cAtt.yy_color = .init(hex: "#FFDE5E")
                let hi = YYTextHighlight()
                hi.tapAction =  { [weak self] containerView, text, range, rect in
                    guard let self = self else { return }
                    MobClick.event("songs_bottomCash", attributes: [
                        "type" : "提现",
                    ])
                    self.delegate?.homeDidSelectedCash(controller: self, level: self.currentSong?.level)
                }
                cAtt.yy_setTextHighlight(hi, range: cAtt.yy_rangeOfAll())
                
                textAtt.append(aAtt)
                textAtt.append(bAtt)
                textAtt.append(cAtt)
                
                self.markGetCashBtn.rx.tap.subscribe(onNext: {[weak self] _ in
                    
                    guard let self = self else { return }
                    self.delegate?.homeDidSelectedCash(controller: self, level: self.currentSong?.level)
                    
                }).disposed(by: self.markGetCashBtnDisposeBag)
            }
            textAtt.yy_alignment = .center
            self.goToCashLbl.attributedText = textAtt
            
        }).disposed(by: rx.disposeBag)
        
        let input = HomeViewModel.Input(play: requestNextMusic.asObservable(),
                                        showErrorAnswer: showErrorAnswer)
        let output = viewModel.transform(input: input)
        
        output.play.subscribe(onNext: { [weak self]  song in
            guard let song = song else { return }
            guard let self = self else { return }
            self.currentSong = song
            MusicPlayer.shared.play(url: song.url)
            self.levelLbl1.attributedText = self.getLevelAttStr(str: "第\(song.level ?? 0)关")
            self.levelLbl2.attributedText = self.getLevelAttStr(str: "第\(song.level ?? 0)关")
            
        }).disposed(by: rx.disposeBag)
        
        output.songs.subscribe(onNext: {[weak self] items in
            if items.count != 3 { return }
            guard let self = self else { return }
            
            if !UserManager.shared.isCheck {
                self.leftView.isHidden = false
            }
            self.rightView.isHidden = false
            
            self.avatarSelecteView?.removeFromSuperview()
            self.avatarSelecteView = self.getAvatorImgView()
            
            self.createOtherAvatorImgViews()
            
            self.answerBgView.removeSubviews()
            
            self.waitView.isHidden = false
            self.countView.isHidden = true
            self.resultStatuView.isHidden = true
            
            let answer1 = AnswerView(viewModel: items[0])
            self.answerBgView.addSubview(answer1)
            
            let answer2 = AnswerView(viewModel: items[1])
            answer2.y = answer1.frame.maxY + 8.uiX
            
            self.answerBgView.addSubview(answer2)
            
            let answer3 = AnswerView(viewModel: items[2])
            answer3.y = answer2.frame.maxY + 8.uiX
            self.answerBgView.addSubview(answer3)
            
            answer1.transform = .init(scaleX: 0.7, y: 0.7)
            answer3.transform = .init(scaleX: 0.7, y: 0.7)
            answer2.transform = .init(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 0.25) {
                answer1.transform = .identity
                answer2.transform = .identity
                answer3.transform = .identity
            }
            
        }).disposed(by: rx.disposeBag)
        
        output.showTimeStatus.subscribe(onNext: {[weak self] count in
            guard let self = self else { return }
            self.waitView.isHidden = true
            self.resultStatuView.isHidden = true
            self.countView.isHidden = false
            self.timeCountLbl.attributedText = self.getCountAttStr(num: count)
//            if count == 2 || count == 1 {
//                UIView.animate(withDuration: 0.5) {
//                    self.randomOtherAvators2()
//                }
//            }
        }).disposed(by: rx.disposeBag)
        
        output.showResultStatus.subscribe(onNext: { [weak self] s in
            guard let self = self else { return }
            self.waitView.isHidden = true
            self.resultStatuView.isHidden = false
            self.countView.isHidden = true
            self.resultImgView.image = .create(s ? "img_correct" : "img_wrong")
            self.resultLbl.attributedText = self.getStatusAttStr(str: s ? "答对了" : "答错了")
        }).disposed(by: rx.disposeBag)
        
        output.showDiamond.subscribe(onNext: { [weak self] m in
            guard let self = self else { return }
            let pop = CoinPopView(model: m)
            pop.action = { b in
                self.requestNextMusic.accept((m, false))
            }
            PopView.show(view: pop)
        }).disposed(by: rx.disposeBag)
        
        output.showRedBag.subscribe(onNext: { [weak self] m in
            guard let self = self else { return }
            if m.level <= 4 {
                let pop = NewUserPlaySuccessView(cash: m.cash, level: m.withdrawLevel)
                pop.action = { [weak self] in
                    guard let self = self else { return }
                    self.requestNextMusic.accept((m, false))
                }
                PopView.show(view: pop)
            } else if m.level == 5 {
                let pop = NewUserPlayCashView()
                pop.action = { [weak self] in
                    guard let self = self else { return }
                    self.requestNextMusic.accept((m, false))
                    self.delegate?.homeDidSelectedCash(controller: self, level: (self.currentSong?.level ?? 0 ) + 1 )
                }
                pop.closeAction = { [weak self] in
                    guard let self = self else { return }
                    self.requestNextMusic.accept((m, false))
                }
                PopView.show(view: pop)
            } else {
                let completion = { [weak self] in
                    guard let self = self else { return }
                    let pop = PlaySuccessView(cash: m.cash, level: m.withdrawLevel, cashAd: m.cashAd)
                    pop.action = { [weak self] in
                        guard let self = self else { return }
                        self.requestNextMusic.accept((m, true))
                    }
                    pop.nextAction = { [weak self] in
                        guard let self = self else { return }
                        self.requestNextMusic.accept((m, false))
                    }
                    PopView.show(view: pop)
                }
                if m.isAd {
                    MobClick.event("video_forceToSee")
                    self.rewardAd.completion = completion
                    self.rewardAd.failure = completion
                    self.rewardAd.showAd(vc: self)
                } else {
                    completion()
                }
            }
        }).disposed(by: rx.disposeBag)
        
        output.showAvatarSelected.subscribe(onNext: { [weak self] (isFrist, idx, rightIdx) in
            guard let self = self else { return }
            
            self.leftView.isHidden = true
            self.rightView.isHidden = true
            
            var y:CGFloat = 0
            switch idx {
            case 0:
                y = 8.uiX
            case 1:
                y = 107.5.uiX + 8.uiX
            default:
                y = 107.5.uiX * 2 + 8.uiX
            }
            let x: CGFloat = (self.answerBgView.width - (self.avatarSelecteView?.width ?? 0))/2.0
            let origin = self.answerBgView.convert(.init(x: x, y: y), to: self.contentView)
            UIView.animate(withDuration: 0.25) {
                self.avatarSelecteView?.x = origin.x
                self.avatarSelecteView?.y = origin.y
                if isFrist {
                    self.randomOtherAvators(right: rightIdx)
                }
            }
        }).disposed(by: rx.disposeBag)
        
        output.showLifeView.subscribe(onNext: { _ in
            PopView.show(view: LifePopView())
        }).disposed(by: rx.disposeBag)
        
        output.showMsg.bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        let bgView = UIImageView(image: UIImage(named: "home_img_bgd"))
        bgView.contentMode = .scaleAspectFill
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
        
//        contentView.borderColor = .red
//        contentView.borderWidth = 0.5
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(667.uiX)
        }
        
        setupContentView()
        setupBottomBar()
        
    }
    
    private func setupBottomBar() {
        let bgView = UIView()
        bgView.backgroundColor = .init(hex: "#4C1692")
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(44.uiX + UIDevice.safeAreaBottom)
        }
        
        goToCashLbl.textAlignment = .center
        bgView.addSubview(goToCashLbl)
        goToCashLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15.uiX)
        }
        
        let fingerImg = UIImage.create("sy-qtx-sz-icon")
        fingerImgView.image = fingerImg
        bgView.addSubview(fingerImgView)
        fingerImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-15.uiX)
            make.size.equalTo(fingerImg.snpSize)
            make.right.equalToSuperview().offset(-60.uiX)
        }
        
        let ro = CABasicAnimation(keyPath: "transform.scale")
        ro.fromValue = 0.9
        ro.toValue = 1
        ro.duration = 0.5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = false
        ro.autoreverses = true
        ro.fillMode = .forwards
        fingerImgView.layer.add(ro, forKey: "rotationAnimation")
        
        if UserManager.shared.isCheck {
            bgView.isHidden = true
        }
    }
    
    private func setupContentView() {
        
        setupTopBar()
        setupTitleView()
        setupAnswerView()
        setupLeftView()
        setupRightView()
        setup1000View()
    }
    
    private func setup1000View() {
        let btnImg = UIImage.create("sy-100w-icon")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.size
        btn.y = 68.uiX
        btn.x = 276.uiX
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            guard let s = self.currentSong else { return }
            MobClick.event("songs_1000")
            PopView.show(view: LevelPopView(song: s))
        }).disposed(by: rx.disposeBag)
        contentView.addSubview(btn)
        
        if UserManager.shared.isCheck {
            btn.isHidden = true
        }
    }
    
    private func setupLeftView() {
        leftView = HomeLeftView(x: 0, y: 268.5.uiX)
        leftView.btn2.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            MobClick.event("songs_sign")
            let pop = SignPopView()
            pop.cashAction = { [weak self] b in
                guard let self = self else { return }
                if b {
                    self.showLotteryView(type: 2)
                } else {
                    self.delegate?.homeDidSelectedCash(controller: self, level: self.currentSong?.level)
                }
            }
            PopView.show(view: pop)
        }).disposed(by: rx.disposeBag)
        leftView.btn1.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            PopView.show(view: TimeRedBagView(action: { [weak self] in
                guard let self = self else { return }
                self.delegate?.homeDidSelectedCash(controller: self, level: self.currentSong?.level)
                }, success: { [weak self] in
                    guard let self = self else { return }
                    self.leftView.resetTime()
            }))
        }).disposed(by: rx.disposeBag)
        contentView.addSubview(leftView)
        
        if UserManager.shared.isCheck {
            leftView.isHidden = true
        }
    }
    
    private func setupRightView() {
        rightView = HomeRightView(x: UIDevice.screenWidth - 57.uiX, y: 436.5.uiX)
        rightView.btn1.rx.tap.subscribe(onNext: { _ in
            MobClick.event("songs_songlevels")
            PopView.show(view: MusicPopView())
        }).disposed(by: rx.disposeBag)
        rightView.btn2.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            MobClick.event("songs_props")
            guard let user = UserManager.shared.login.value.0 else { return }
            if user.singleNum > 0 {
                self.showErrorAnswer.accept(())
            } else {
                MobClick.event("video_deleteAnswer")
                self.rewardAd.completion = { [weak self] in
                    guard let self = self else { return }
                    self.showErrorAnswer.accept(())
                }
                self.rewardAd.showAd(vc: self)
            }
        }).disposed(by: rx.disposeBag)
        contentView.addSubview(rightView)
    }
    
    private func setupAnswerView() {
//        answerBgView.borderColor = .red
//        answerBgView.borderWidth = 0.5
        answerBgView.width = 248.uiX
        answerBgView.height = 320.uiX
        answerBgView.y = 255.uiX
        answerBgView.x = (UIDevice.screenWidth - answerBgView.width)/2.0
        contentView.addSubview(answerBgView)
        
    }
    
    private func setupTitleView() {
        
        let titleBgImg = UIImage.create("home_img_title_bgd")
        let titleBgView = UIImageView(image: titleBgImg)
        titleBgView.size = titleBgImg.snpSize
        titleBgView.x = (UIDevice.screenWidth - titleBgView.width)/2.0
        titleBgView.y = 107.5.uiX
        contentView.addSubview(titleBgView)
        
        let gradientViewWidth = 300.uiX
        let gradientViewX = (UIDevice.screenWidth - gradientViewWidth)/2.0
        let (gradientView1, lbl1) = getGradientTextView(
            rect: CGRect(x: gradientViewX, y: 85.uiX, width: gradientViewWidth, height: 40.uiX),
            colors: [UIColor(hex: "#FFFFFF"), UIColor(hex: "#DA92FF")])
        let (gradientView2, lbl2) = getGradientTextView(
            rect: CGRect(x: gradientViewX + 2.uiX, y: 86.5.uiX, width: gradientViewWidth, height: 40.uiX),
            colors: [UIColor(hex: "#270896"), UIColor(hex: "#7D017C")])
        contentView.addSubview(gradientView2)
        contentView.addSubview(gradientView1)
        levelLbl1 = lbl1
        levelLbl2 = lbl2
        
        let statusView = UIView()
        statusView.x = 0
        statusView.y = titleBgView.frame.maxY
        statusView.width = UIDevice.screenWidth
        statusView.height = 129.uiX
        contentView.addSubview(statusView)
        
        waitView.frame = statusView.bounds
        statusView.addSubview(waitView)
        setupWaitView(view: waitView)
        
        countView.frame = statusView.bounds
        countView.isHidden = true
        statusView.addSubview(countView)
        setupCountView(view: countView)
        
        resultStatuView.frame = statusView.bounds
        resultStatuView.isHidden = true
        statusView.addSubview(resultStatuView)
        setupResultStatuView(view: resultStatuView)

    }
    
    private func setupResultStatuView(view: UIView) {
        let img = UIImage.create("img_correct")
        resultImgView.image = img
        resultImgView.size = img.snpSize
        resultImgView.y = 26.uiX
        resultImgView.x = (view.width - resultImgView.width)/2.0
        view.addSubview(resultImgView)

        resultLbl.height = 17.uiX
        resultLbl.width = view.width
        resultLbl.x = 0
        resultLbl.y = 96.uiX
        resultLbl.textAlignment = .center
        resultLbl.attributedText = getStatusAttStr(str: "答对了")
        view.addSubview(resultLbl)
        
    }
    
    private func getStatusAttStr(str: String) -> NSAttributedString {
        let att: [NSAttributedString.Key : Any] = [
            .font: UIFont(style: .bold, size: 18.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF"),
            .strokeColor: UIColor(hex: "#901AEE"),
            .strokeWidth: -6.uiX
        ]
        return .init(string: str, attributes: att)
    }
    
    private func setupCountView(view: UIView) {
        let bgView = UIView()
        bgView.width = 71.uiX
        bgView.height = 71.uiX
        bgView.y = 18.uiX
        bgView.x = (view.width - bgView.width)/2.0
        bgView.cornerRadius = 71.uiX/2.0
        bgView.borderWidth = 2.5.uiX
        bgView.borderColor = .init(hex: "#F08BFF")
        bgView.backgroundColor = .init(hex: "#800DAA")
        view.addSubview(bgView)
        
        timeCountLbl.frame = bgView.bounds
        timeCountLbl.textAlignment = .center
        timeCountLbl.attributedText = getCountAttStr(num: 0)
        bgView.addSubview(timeCountLbl)
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#FFFFFF")
        textLbl.font = .init(style: .regular, size: 15.uiX)
        textLbl.text = "倒计时结束前可修改答案"
        textLbl.height = 14.5.uiX
        textLbl.width = view.width
        textLbl.x = 0
        textLbl.y = 101.uiX
        textLbl.textAlignment = .center
        view.addSubview(textLbl)
        
    }
    
    private func getCountAttStr(num: Int) -> NSAttributedString {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(hex: "#F265FF")
        shadow.shadowBlurRadius = 5.uiX
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        let att: [NSAttributedString.Key : Any] = [
            .font: UIFont(name: "DIN-Medium", size: 45.uiX)!,
            .foregroundColor: UIColor(hex: "#FFFFFF"),
            .shadow: shadow
        ]
        return .init(string: "\(num)", attributes: att)
    }
    
    private func setupWaitView(view: UIView) {
        
        redBagNumlbl.textColor = .init(hex: "#FFFFFF")
        redBagNumlbl.font = .init(style: .regular, size: 11.uiX)
        redBagNumlbl.height = 11.uiX
        redBagNumlbl.x = 0
        redBagNumlbl.y = 8.uiX
        redBagNumlbl.textAlignment = .center
        redBagNumlbl.width = view.width
        view.addSubview(redBagNumlbl)
        
        let progressBgView = UIView()
        progressBgView.width = 170.uiX
        progressBgView.height = 10.uiX
        progressBgView.y = redBagNumlbl.frame.maxY + 8.uiX
        progressBgView.x = (UIDevice.screenWidth - progressBgView.width)/2.0
        progressBgView.backgroundColor = .init(hex: "#1F135A")
        progressBgView.cornerRadius = 5.uiX
        progressBgView.borderColor = .init(hex: "#DA862D")
        progressBgView.borderWidth = 1.uiX
        view.addSubview(progressBgView)
        
        let progressGra = [UIColor.init(hex: "#FD9C14"), UIColor.init(hex: "#E56B00")].gradient()
        progressGra.startPoint = .init(x: 0, y: 0)
        progressGra.endPoint = .init(x: 1, y: 0)
        progressGra.frame = progressBgView.bounds
        
        let progressInnerView = UIView()
        progressInnerView.frame = progressBgView.bounds
        progressInnerView.backgroundColor = .init(hex: "#ffffff")
        progressInnerView.layer.addSublayer(progressGra)
        progressBgView.addSubview(progressInnerView)
        
        progressView.frame = progressBgView.bounds
        progressView.width = 50.uiX
        progressView.backgroundColor = .init(hex: "#ffffff")
        progressInnerView.mask = progressView
        
        let redBagImg = UIImage.create("tx-jbye-hb-icon")
        let redBag = UIImageView(image: redBagImg)
        redBag.x = progressBgView.frame.maxX + 7.uiX
        redBag.size = redBagImg.snpSize
        redBag.y = 19.uiX
        view.addSubview(redBag)
        
        markGetCashBtn.frame = redBag.frame
        view.addSubview(markGetCashBtn)
        
        let markGetCashViewImg = UIImage.create("sy-ktx-icon")
        markGetCashView.image = markGetCashViewImg
        markGetCashView.size = markGetCashViewImg.snpSize
        markGetCashView.center.x = redBag.center.x
        markGetCashView.y = redBag.frame.minY - markGetCashView.height - 1.5.uiX
        view.addSubview(markGetCashView)
        
        let markGetCashLbl = UILabel()
        markGetCashLbl.textColor = .init(hex: "#ffffff")
        markGetCashLbl.font = .init(style: .medium, size: 9.uiX)
        markGetCashLbl.textAlignment = .center
        markGetCashLbl.text = "可提现"
        markGetCashLbl.width = markGetCashView.width
        markGetCashLbl.height = 8.5.uiX
        markGetCashLbl.y = 3.uiX
        markGetCashView.addSubview(markGetCashLbl)
        
        levelToLevelbl.textColor = .init(hex: "#FFE248")
        levelToLevelbl.font = .init(style: .regular, size: 9.uiX)
        levelToLevelbl.textAlignment = .center
        levelToLevelbl.height = 8.5.uiX
        levelToLevelbl.width = 100.uiX
        levelToLevelbl.y = redBag.frame.maxY + 3.5.uiX
        levelToLevelbl.center.x = redBag.center.x
        view.addSubview(levelToLevelbl)
        
        if UserManager.shared.isCheck {
            progressBgView.isHidden = true
            redBag.isHidden = true
            markGetCashBtn.isHidden = true
            redBagNumlbl.isHidden = true
            levelToLevelbl.isHidden = true
            markGetCashView.isHidden = true
        }
        
        let animation1 = Animation.named("data", subdirectory: "3")
        let animationView1 = AnimationView(animation: animation1)
        animationView1.contentMode = .scaleAspectFill
        animationView1.y = progressBgView.frame.maxY + 33.uiX
        animationView1.width = 235.5.uiX
        animationView1.height = 41.5.uiX
        animationView1.x = UIDevice.screenWidth - animationView1.width - 61.5.uiX
        animationView1.loopMode = .loop
        animationView1.backgroundBehavior = .pauseAndRestore
        view.addSubview(animationView1)
        animationView1.play()
        
        let animation = Animation.named("data", subdirectory: "2")
        let animationView = AnimationView(animation: animation)
        animationView.contentMode = .scaleAspectFill
        animationView.y = progressBgView.frame.maxY - 2.uiX
        animationView.width = 85.uiX
        animationView.height = 90.uiX
        animationView.x = 48.uiX
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        view.addSubview(animationView)
        animationView.play()
        
        let namelbl = UILabel()
        namelbl.textColor = .init(hex: "#FFFFFF")
        namelbl.font = .init(style: .regular, size: 18.uiX)
        namelbl.text = "你听到的歌曲是？"
        namelbl.height = 17.uiX
        namelbl.width = 150.uiX
        namelbl.x = (UIDevice.screenWidth - namelbl.width)/2.0 + 8.uiX
        namelbl.y = progressBgView.frame.maxY + 45.uiX
        namelbl.textAlignment = .left
        view.addSubview(namelbl)
        
    }
    
    private func setupTopBar() {
        let avatarBgView = UIView(frame: CGRect(x: 8, y: 17, width: 42, height: 42).uiX)
        avatarBgView.backgroundColor = .init(hex: "#F08BFF")
        avatarBgView.cornerRadius = 21.uiX
        avatarBgView.rx.tap().subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            MobClick.event("songs_avatar")
            self.delegate?.homeDidSelectedMine(controller: self)
        }).disposed(by: rx.disposeBag)
        
        avatarImgView.width = 40.uiX
        avatarImgView.height = 40.uiX
        avatarImgView.y = (avatarBgView.height - avatarImgView.height)/2.0
        avatarImgView.x = (avatarBgView.width - avatarImgView.width)/2.0
        avatarImgView.cornerRadius = 20.uiX
        avatarImgView.borderColor = .init(hex: "#1E115D")
        avatarImgView.borderWidth = 1.uiX
        avatarBgView.addSubview(avatarImgView)
        
        let redBagBgViewHeight: CGFloat = 24.5
        let redBagBgView = UIView(frame: CGRect(x: 31, y: 25.5, width: 116.5, height: redBagBgViewHeight).uiX)
        redBagBgView.backgroundColor = .init(hex: "#460E66")
        redBagBgView.cornerRadius = redBagBgViewHeight.uiX/2.0
        contentView.addSubview(redBagBgView)
        
        let redBagBtnImg = UIImage.create("sy-tx-icon")
        let redBagBtn = MusicButton()
        redBagBtn.rx.tap.subscribe {[weak self] _ in
            guard let self = self else { return }
            MobClick.event("songs_topCash")
            self.delegate?.homeDidSelectedCash(controller: self, level: self.currentSong?.level)
        }.disposed(by: rx.disposeBag)
        redBagBtn.setBackgroundImage(redBagBtnImg, for: .normal)
        redBagBtn.size = redBagBtnImg.snpSize
        redBagBtn.x = 114.uiX
        redBagBtn.center.y = redBagBgView.center.y
        contentView.addSubview(redBagBtn)
        
        cashlbl.textColor = .init(hex: "#ffffff")
        cashlbl.font = .init(style: .bold, size: 14.uiX)
        cashlbl.y = redBagBgView.y
        cashlbl.x = 50.uiX
        cashlbl.width = 64.uiX
        cashlbl.height = redBagBgView.height
        cashlbl.text = "0"
        cashlbl.textAlignment = .center
        cashlbl.adjustsFontSizeToFitWidth = true
        contentView.addSubview(cashlbl)
        
        let cashBgViewHeight: CGFloat = 24.5
        let cashBgView = UIView(frame: CGRect(x: 179, y: 25.5, width: 100, height: cashBgViewHeight).uiX)
        cashBgView.backgroundColor = .init(hex: "#460E66")
        contentView.addSubview(cashBgView)
        
        contentView.addSubview(avatarBgView)
        
        let diamondImg = UIImage.create("sy-jb-icon")
        let diamond = UIImageView(image: diamondImg)
        diamond.x = 166.uiX
        diamond.size = diamondImg.snpSize
        diamond.center.y = cashBgView.center.y
        contentView.addSubview(diamond)
        
        let cashBtnImg = UIImage.create("sy-chb-icon")
        let cashBtn = MusicButton()
        cashBtn.rx.tap.subscribe {[weak self] _ in
            guard let self = self else { return }
            MobClick.event("songs_openPacket")
            let n = UserManager.shared.user?.convert ?? 0
            let nMax = UserManager.shared.configure?.songAd.convertMax ?? 0
            if n >= nMax {
                Observable<String>.just("今日拆红包数量已满").bind(to: self.view.rx.toastText()).disposed(by: self.rx.disposeBag)
                return
            }
            let max = UserManager.shared.configure?.songAd.convertGold ?? 0
            let current = UserManager.shared.user?.gold ?? 0
            if current < max {
                MobClick.event("openPacket_success")
                PopView.show(view: CoinAlertPopView())
            } else {
                PopView.show(view: DiamondRedBagView(action: {
                    
                }))
            }
        }.disposed(by: rx.disposeBag)
        cashBtn.setBackgroundImage(cashBtnImg, for: .normal)
        cashBtn.size = cashBtnImg.snpSize
        cashBtn.center.y = cashBgView.center.y
        cashBtn.x = 247.5.uiX
        contentView.addSubview(cashBtn)
        
        diamondlbl.textColor = .init(hex: "#ffffff")
        diamondlbl.font = .init(style: .bold, size: 14.uiX)
        diamondlbl.adjustsFontSizeToFitWidth = true
        diamondlbl.y = 0
        diamondlbl.x = 12.uiX
        diamondlbl.width = 56.uiX
        diamondlbl.height = cashBgView.height
        diamondlbl.text = "0"
        diamondlbl.textAlignment = .center
        cashBgView.addSubview(diamondlbl)
        
        let lifeBgViewHeight: CGFloat = 24.5
        let lifeBgView = UIView(frame: CGRect(x: 299.5, y: 25.5, width: 69.5, height: lifeBgViewHeight).uiX)
        lifeBgView.backgroundColor = .init(hex: "#460E66")
        lifeBgView.cornerRadius = lifeBgViewHeight.uiX/2.0
        contentView.addSubview(lifeBgView)
        
        let redHeartImg = UIImage.create("sy-tl-icon")
        let redHeart1 = UIImageView(image: redHeartImg)
        redHeart1.x = 5.5.uiX
        redHeart1.size = redHeartImg.snpSize
        redHeart1.y = (lifeBgView.height - redHeart1.height)/2.0
        lifeBgView.addSubview(redHeart1)
        lifeImgViews.append(redHeart1)
        
        let redHeart2 = UIImageView(image: redHeartImg)
        redHeart2.x = redHeart1.frame.maxX + 3.uiX
        redHeart2.size = redHeartImg.snpSize
        redHeart2.y = (lifeBgView.height - redHeart2.height)/2.0
        lifeBgView.addSubview(redHeart2)
        lifeImgViews.append(redHeart2)
        
        let redHeart3 = UIImageView(image: redHeartImg)
        redHeart3.x = redHeart2.frame.maxX + 3.uiX
        redHeart3.size = redHeartImg.snpSize
        redHeart3.y = (lifeBgView.height - redHeart3.height)/2.0
        lifeBgView.addSubview(redHeart3)
        lifeImgViews.append(redHeart3)
        
        lifeViewlbl.x = lifeBgView.x
        lifeViewlbl.y = lifeBgView.frame.maxY
        lifeViewlbl.height = 20.uiX
        lifeViewlbl.width = lifeBgView.width
        lifeViewlbl.textColor = .init(hex: "#B0F7FF")
        lifeViewlbl.font = .init(style: .regular, size: 10.uiX)
        lifeViewlbl.textAlignment = .center
        contentView.addSubview(lifeViewlbl)
        
        if UserManager.shared.isCheck {
            redBagBgView.isHidden = true
            redBagBtn.isHidden = true
            cashBtn.isHidden = true
            cashBgView.x = avatarBgView.frame.maxX + 5.uiX
            lifeBgView.x = cashBgView.frame.maxX + 5.uiX
            lifeViewlbl.center.x = lifeBgView.center.x
//            cashBgView.isHidden = true
            cashlbl.isHidden = true
            cashBgView.x = 40.uiX
            diamond.x = 130.uiX
        }
    }
    
    
    private func getGradientTextView(rect: CGRect, colors: [UIColor]) -> (UIView, UILabel) {
        
        let titleGradientLayer = colors.gradient()
        let gradientView = UIView(frame: rect)
        titleGradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        titleGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        titleGradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(titleGradientLayer)

        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.attributedText = getLevelAttStr(str: "第1关")
        lbl.textAlignment = .center
        lbl.frame = gradientView.bounds
        gradientView.mask = lbl
        
        return (gradientView, lbl)
    }
    
    private func getLevelAttStr(str: String) -> NSAttributedString {
        
        let att: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.obliqueness : 0.2,
            NSAttributedString.Key.font : UIFont(name: "Tensentype-JiaLiZhunCuYuanJ", size: 35.uiX)!,
        ]
        return .init(string: str, attributes: att)
    }
    
    private func getAvatorImgView() -> UIView {
        let v = UIImageView()
        let url = UserManager.shared.login.value.0?.avatar ?? ""
        v.kf.setImage(with: URL(string: url))
        v.x = Bool.random() ? -45.uiX : UIDevice.screenWidth
        v.y = CGFloat.random(in: 255.uiX..<570.uiX)
        v.width = 45.uiX
        v.height = 45.uiX
        v.cornerRadius = 45.uiX / 2.0
        v.borderColor = .init(hex: "#FFE21D")
        v.borderWidth = 1.5.uiX
        v.backgroundColor = .init(hex: "#5E7FEA")
        contentView.addSubview(v)
        return v
    }
    
    private func getOtherAvatorImgView() -> UIView {
        let v = UIImageView()
        let url = (UserManager.shared.configure?.staticDomain ?? "") + "/ai_avatar/\(Int.random(in: 1...2000)).png"
        v.kf.setImage(with: URL(string: url))
        v.x = Bool.random() ? -45.uiX : UIDevice.screenWidth
        v.y = CGFloat.random(in: 255.uiX..<570.uiX)
        v.width = 32.uiX
        v.height = 32.uiX
        v.cornerRadius = 32.uiX / 2.0
        v.borderColor = .init(hex: "#5E7FEA")
        v.borderWidth = 1.uiX
        v.backgroundColor = .init(hex: "#F08BFF")
        contentView.addSubview(v)
        return v
    }
    
    private let otherAvatorNumMax = 5
    private let otherAvatorNumMin = 2
    private var otherAvators = [UIView]()
    private var otherAvatorSection1 = [UIView]()
    private var otherAvatorSection2 = [UIView]()
    private var otherAvatorSection3 = [UIView]()
    private var otherAvatorRightPower = 0.6
    private let otherAvatorOrigins1: [CGPoint] = [
        .init(x: 15.uiX, y: 7.5.uiX),
        .init(x: 48.uiX, y: 7.5.uiX),
        .init(x: 175.5.uiX, y: 7.5.uiX),
        .init(x: 210.uiX, y: 7.5.uiX),
    ]
    private let otherAvatorOrigins2: [CGPoint] = [
        .init(x: 15.uiX, y: 115.uiX),
        .init(x: 48.uiX, y: 115.uiX),
        .init(x: 175.5.uiX, y: 115.uiX),
        .init(x: 210.uiX, y: 115.uiX),
    ]
    private let otherAvatorOrigins3: [CGPoint] = [
        .init(x: 15.uiX, y: 222.5.uiX),
        .init(x: 48.uiX, y: 222.5.uiX),
        .init(x: 175.5.uiX, y: 222.5.uiX),
        .init(x: 210.uiX, y: 222.5.uiX),
    ]
    
    private func createOtherAvatorImgViews() {
        let n = Int.random(in: otherAvatorNumMin...otherAvatorNumMax)
        otherAvators.forEach{ $0.removeFromSuperview() }
        otherAvators.removeAll()
        otherAvatorSection1.removeAll()
        otherAvatorSection2.removeAll()
        otherAvatorSection3.removeAll()
        
        for _ in 0..<n {
            otherAvators.append(getOtherAvatorImgView())
        }
    }
    
    private func randomOtherAvators(right: Int) {
        
        var rightSection1 = [UIView]()
        var section2 = [UIView]()
        var section1 = [UIView]()
        
        for v in otherAvators {
            switch Float.random(in: 0...1) {
            case 0...0.6:
                if rightSection1.count < 4 {
                    rightSection1.append(v)
                }
            default:
                switch Int.random(in: 0...1) {
                case 0:
                    if section1.count < 4 {
                        section1.append(v)
                    }
                default:
                    if section2.count < 4 {
                        section2.append(v)
                    }
                }
            }
        }
        
        switch right {
        case 0:
            otherAvatorSection1.append(contentsOf: rightSection1)
            otherAvatorSection2.append(contentsOf: section1)
            otherAvatorSection3.append(contentsOf: section2)
        case 1:
            otherAvatorSection2.append(contentsOf: rightSection1)
            otherAvatorSection1.append(contentsOf: section1)
            otherAvatorSection3.append(contentsOf: section2)
        default:
            otherAvatorSection3.append(contentsOf: rightSection1)
            otherAvatorSection1.append(contentsOf: section1)
            otherAvatorSection2.append(contentsOf: section2)
        }
        
        otherAvatorSection1.enumerated().forEach { e in
            e.element.tag = 1
            otherAvatarsReloadFrame(v: e.element, origin: otherAvatorOrigins1[e.offset])
        }
        otherAvatorSection2.enumerated().forEach { e in
            e.element.tag = 2
            otherAvatarsReloadFrame(v: e.element, origin: otherAvatorOrigins2[e.offset])
        }
        otherAvatorSection3.enumerated().forEach { e in
            e.element.tag = 3
            otherAvatarsReloadFrame(v: e.element, origin: otherAvatorOrigins3[e.offset])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5) {
                self.randomOtherAvators2()
            }
        }
        
    }
    
    private var otherAvatorChangePower = 0.5
    private func randomOtherAvators2() {
        
        var all = otherAvatorSection1 + otherAvatorSection2 + otherAvatorSection3
        let changeCount = (all.count.float * 0.5).int
        if changeCount == 0 {
            return
        }
        var choose = 0
        var changeV = [UIView]()
        while choose < changeCount {
            choose += 1
            let ranIdx = Int.random(in: 0..<all.count)
            let obj = all.remove(at: ranIdx)
            otherAvatorSection1.removeAll(obj)
            otherAvatorSection2.removeAll(obj)
            otherAvatorSection3.removeAll(obj)
            changeV.append(obj)
        }
        
        changeV.forEach { v in
            switch v.tag {
            case 1:
                v.tag = Int.random(in: 2...3)
            case 2:
                v.tag = Bool.random() ? 1 : 3
            default:
                v.tag = Int.random(in: 1...2)
            }
            
            switch v.tag {
            case 1:
                if otherAvatorSection1.count < 4 {
                    otherAvatorSection1.append(v)
                }
            case 2:
                if otherAvatorSection2.count < 4 {
                    otherAvatorSection2.append(v)
                }
            default:
                if otherAvatorSection3.count < 4 {
                    otherAvatorSection3.append(v)
                }
            }
        }
        
        otherAvatorSection1.enumerated().forEach { e in
            otherAvatarsReloadFrame(v: e.element, origin: otherAvatorOrigins1[e.offset])
        }
        otherAvatorSection2.enumerated().forEach { e in
            otherAvatarsReloadFrame(v: e.element, origin: otherAvatorOrigins2[e.offset])
        }
        otherAvatorSection3.enumerated().forEach { e in
            otherAvatarsReloadFrame(v: e.element, origin: otherAvatorOrigins3[e.offset])
        }
    }
    
    
    private func otherAvatarsReloadFrame(v: UIView, origin: CGPoint) {
        let o = self.answerBgView.convert(origin, to: self.contentView)
        v.x = o.x
        v.y = o.y
    }

}
