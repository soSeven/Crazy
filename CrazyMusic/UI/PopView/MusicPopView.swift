//
//  MusicPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/10.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MusicPopView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 241.5.uiX, height: 44.uiX)
        layout.minimumLineSpacing = 10.uiX
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(cellType: MusicPopCell.self)
        
        return collectionView
    }()
    
    var currentIndex: Int?
    
    init() {
        let bgImg = UIImage.create("choose_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
    
        let titleImg = UIImage.create("choose_img_title")
        let titleImgView = UIImageView(image: titleImg)
        titleImgView.size = titleImg.snpSize
        titleImgView.y = 22.uiX
        titleImgView.x = (width - titleImgView.width)/2.0
        addSubview(titleImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#EADADA")
        titleLbl.font = .init(style: .regular, size: 14.uiX)
        titleLbl.text = "选择喜欢的歌曲类型体验更佳哦！"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 13.5.uiX
        titleLbl.y = 71.uiX
        addSubview(titleLbl)
        
        let closeImg = UIImage.create("choose_icon_close")
        let closeBtn = Button()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 15.5.uiX
        closeBtn.x = width - closeBtn.width - 19.uiX
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(closeBtn)
        
//        let textLbl = UILabel()
//        textLbl.textColor = .init(hex: "#EADADA")
//        textLbl.font = .init(style: .regular, size: 14.uiX)
//        textLbl.text = "此次更改，会在下一关开始生效"
//        textLbl.textAlignment = .center
//        textLbl.width = width
//        textLbl.height = 14.uiX
//        textLbl.y = 388.uiX
//        addSubview(textLbl)
        
        let btnImg = UIImage.create("choose_img_btn_continue")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 396.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            if let idx = self.currentIndex,
                let items = UserManager.shared.configure?.musicType,
                idx < items.count {
                let item = items[idx]
                NetManager.requestResponse(.changeMusic(id: item.id)).subscribe(onSuccess: { _ in
                    self.showMsg(msg: "更换歌曲类型成功")
                    guard let user = UserManager.shared.login.value.0 else { return }
                    user.musicType = item.id
                    UserManager.shared.login.accept((user, .change))
                }) { _ in
                    self.showMsg(msg: "更换歌曲类型失败")
                }.disposed(by: UserManager.shared.rx.disposeBag)
            }

        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        collectionView.width = 241.5.uiX
        collectionView.height = 54.uiX * 5
        collectionView.y = 106.5.uiX
        collectionView.x = (width - collectionView.width)/2.0
        addSubview(collectionView)
        
        if let items = UserManager.shared.configure?.musicType {
            Observable.just(items).debug().bind(to: collectionView.rx.items(cellIdentifier: MusicPopCell.reuseIdentifier, cellType: MusicPopCell.self)) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                var selected = false
                if let current = self.currentIndex {
                    if current == row {
                        selected = true
                    }
                } else {
                    if let type = UserManager.shared.login.value.0?.musicType, type == element.id {
                        selected = true
                    }
                }
                cell.bind(to: element, selected: selected)
            }.disposed(by: rx.disposeBag)

            collectionView.rx.itemSelected.subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.currentIndex = index.row
                self.collectionView.reloadData()
            }).disposed(by: rx.disposeBag)
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
    
    
}
