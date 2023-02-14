//
//  HomeViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

class HomeViewModel: ViewModel, ViewModelType {
    
    private var playDisposeBag = DisposeBag()
    private var timeDisposeBag = DisposeBag()
    
    private var lastSong: SongModel?
    
    struct Input {
        let play: Observable<(SongCellViewModel, Bool)>
        let showErrorAnswer: PublishRelay<Void>
    }
    
    struct Output {
        let songs: BehaviorRelay<[SongCellViewModel]>
        let play: BehaviorRelay<SongModel?>
        let showTimeStatus: PublishRelay<Int>
        let showResultStatus: PublishRelay<Bool>
        let showDiamond: PublishRelay<SongCellViewModel>
        let showMsg: PublishRelay<String>
        let showAvatarSelected: PublishRelay<(Bool, Int, Int)>
        let showLifeView: PublishRelay<Void>
        let showRedBag: PublishRelay<SongCellViewModel>
    }
    
    func transform(input: Input) -> Output {
        
        let songsPublish = BehaviorRelay<[SongCellViewModel]>(value: [])
        let selectedPublish = PublishRelay<SongCellViewModel>()
        let playMusic =  BehaviorRelay<SongModel?>(value: nil)
        let showMsg = PublishRelay<String>()
        
        let showTimeStatus = PublishRelay<Int>()
        let showResultStatus = PublishRelay<Bool>()
        let showDiamond = PublishRelay<SongCellViewModel>()
        let showAvatarSelected =  PublishRelay<(Bool, Int, Int)>()
        let showLifeView = PublishRelay<Void>()
        let showRedBag = PublishRelay<SongCellViewModel>()
        
        let songRequestPublish = BehaviorRelay<SongModel>(value: UserManager.shared.login.value.0!.song)
        lastSong = UserManager.shared.login.value.0!.song
        let play = PublishRelay<(SongCellViewModel, Bool)>()
        Observable.merge(input.play, play.asObservable()).subscribe(onNext: {[weak self] m, b in
            guard let self = self else { return }
            self.requestRight(cash: b ? m.cashAd : m.cash , level: m.level, songId: m.id, isDouble: b).subscribe(onNext: { rightModel in
                if let r = rightModel {
                    songRequestPublish.accept(r.song)
                    guard let user = UserManager.shared.login.value.0 else { return }
                    guard let last = self.lastSong else { return }
                    user.withdrawLevel = last.withdrawLevel
                    user.withdrawLevelAll = last.withdrawLevelAll
                    user.withdrawLevelReal = last.withdrawLevelReal
                    user.withdrawLevelAllReal = last.withdrawLevelAllReal
                    user.isWithdraw = last.isWithdraw
                    UserManager.shared.login.accept((user, .change))
                    self.lastSong = r.song
                }
            }, onError: { _ in
                let message = MessageAlert()
                let title = "温馨提示"
                let text = "请求网络失败，请检查网络是否连接"
                message.titleLbl.text = title
                message.msgLbl.text = text
                message.show()
                message.leftBtn.rx.tap.subscribe(onNext: { _ in
                    play.accept((m, false))
                }).disposed(by: self.rx.disposeBag)
                message.rightBtn.rx.tap.subscribe(onNext: { _ in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    } else {
                        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }).disposed(by: self.rx.disposeBag)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        songRequestPublish.subscribe(onNext: { song in
            if song.content.count < 3 {
                return
            }
            
            self.playDisposeBag = DisposeBag()
            
            let a = SongCellViewModel(text: song.content[0], isRight: true, level: song.level, id: song.id, cash: song.cash, withdrawLevel: song.withdrawLevel, withdrawLevelAll: song.withdrawLevelAll, isWithdraw: song.isWithdraw, isAd: song.isAd, cashAd: song.cashAd)
            let b = SongCellViewModel(text: song.content[1], isRight: false, level: song.level, id: song.id, cash: song.cash, withdrawLevel: song.withdrawLevel, withdrawLevelAll: song.withdrawLevelAll, isWithdraw: song.isWithdraw, isAd: song.isAd, cashAd: song.cashAd)
            let c = SongCellViewModel(text: song.content[2], isRight: false, level: song.level, id: song.id, cash: song.cash, withdrawLevel: song.withdrawLevel, withdrawLevelAll: song.withdrawLevelAll, isWithdraw: song.isWithdraw, isAd: song.isAd, cashAd: song.cashAd)
            
            a.selected.bind(to: selectedPublish).disposed(by: self.playDisposeBag)
            b.selected.bind(to: selectedPublish).disposed(by: self.playDisposeBag)
            c.selected.bind(to: selectedPublish).disposed(by: self.playDisposeBag)
            
            let items = [a, b, c].sorted { _,_ in Int.random(in: 0...1) == 0}
            songsPublish.accept(items)
            playMusic.accept(song)
            
        }).disposed(by: rx.disposeBag)
        
        input.showErrorAnswer.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let user = UserManager.shared.login.value.0 else { return }
            if user.singleNum <= 0 {
                self.requestDelete().subscribe(onNext: { delete in
                    if let d = delete {
                        user.singleNum = d.singleNum
                        UserManager.shared.login.accept((user, .change))
                    }
                }).disposed(by: self.rx.disposeBag)
                return
            }
            let deletes = songsPublish.value.filter { $0.isShowDelete.value }
            if deletes.count > 0 {
                showMsg.accept("一次只能排除一个错误")
                return
            }
            self.requestUseDelete().subscribe(onNext: { delete in
                if let d = delete {
                    user.singleNum = d.singleNum
                    UserManager.shared.login.accept((user, .change))
                    let items = songsPublish.value.filter { !$0.isRight }
                    let sortItems = items.sorted { _,_ in Int.random(in: 0...1) == 0}
                    sortItems.first?.isShowDelete.accept(true)
                }
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        selectedPublish.subscribe(onNext: {[weak self] current in
            guard let self = self else { return }
            guard let user = UserManager.shared.login.value.0 else { return }
            if user.hp <= 0 {
                showLifeView.accept(())
                return
            }
            var isFrist = true
            for m in songsPublish.value where m.isShowSelected.value == true {
                isFrist = false
                break
            }
            if isFrist {
                
                for m in songsPublish.value {
                    m.isShowLabelAnimation.accept(true)
                }
                
                //开始计时
                self.timeDisposeBag = DisposeBag()
                var totalCout = 4
                showTimeStatus.accept(totalCout)
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { count in
                    switch totalCout {
                    case ..<0:
                        break
                    case 0:
                        totalCout -= 1
                        songsPublish.value.forEach{ $0.isShowCompletion.accept(true) }
                        let items = songsPublish.value.filter { $0.isShowSelected.value }
                        if let m = items.first {
                            showResultStatus.accept(m.isRight)
                            if m.isRight, m.level < (UserManager.shared.configure?.songAd.levelError ?? 0) {
                                if let user = UserManager.shared.login.value.0 {
                                    user.cash += m.cash
                                    UserManager.shared.login.accept((user, .change))
                                }
                                if UserManager.shared.isCheck {
                                    showDiamond.accept(m)
                                } else {
                                    showRedBag.accept(m)
                                }
                                
                            } else {
                                YBPlayAudio.fail()
                                Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
                                    songRequestPublish.accept(songRequestPublish.value)
                                }).disposed(by: self.timeDisposeBag)
                                
                                self.requestError(songId: m.id).subscribe(onNext: { errorModel in
                                    if let e = errorModel {
                                        showMsg.accept("生命值 -1")
                                        guard let user = UserManager.shared.login.value.0 else { return }
                                        user.hp = e.hp
                                        UserManager.shared.login.accept((user, .change))
                                    }
                                }).disposed(by: self.rx.disposeBag)
                            }
                        }
                        
                    default:
                        totalCout -= 1
                        showTimeStatus.accept(totalCout)
                    }
                }).disposed(by: self.timeDisposeBag)
            }
            var rightIndex = 0
            for (idx, m) in songsPublish.value.enumerated() {
                if m != current {
                    m.isShowSelected.accept(false)
                }
                if m.isRight {
                    rightIndex = idx
                }
            }
            current.isShowSelected.accept(true)
            showAvatarSelected.accept((isFrist, songsPublish.value.firstIndex(of: current) ?? 0, rightIndex))
            
        }).disposed(by: rx.disposeBag)

        return Output(songs: songsPublish,
                      play: playMusic,
                      showTimeStatus: showTimeStatus,
                      showResultStatus: showResultStatus,
                      showDiamond: showDiamond,
                      showMsg: showMsg,
                      showAvatarSelected: showAvatarSelected,
                      showLifeView: showLifeView,
                      showRedBag: showRedBag)
    }
    
    // MARK: - Request
    
    func requestRight(cash: Int, level: Int, songId: Int, isDouble: Bool) -> Observable<AnswerRightModel?> {
        
        return NetManager.requestObj(.answerRight(cash: cash, level: level, songId: songId, isDouble: isDouble), type: AnswerRightModel.self).trackError(error).trackActivity(loading)
        
    }
    
    func requestError(songId: Int) -> Observable<AnswerErrorModel?> {
        
        return NetManager.requestObj(.answerWrong(songId: songId), type: AnswerErrorModel.self).trackError(error).trackActivity(loading)
        
    }
    
    func requestDelete() -> Observable<AnswerDeleteModel?> {
        
        return NetManager.requestObj(.getDeleteAnswer, type: AnswerDeleteModel.self).trackError(error).trackActivity(loading)
        
    }
    
    func requestUseDelete() -> Observable<AnswerDeleteModel?> {
        
        return NetManager.requestObj(.useDeleteAnswer, type: AnswerDeleteModel.self).trackError(error).trackActivity(loading)
        
    }
    
}
