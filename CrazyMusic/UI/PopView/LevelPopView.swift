//
//  LevelPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/27.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import YYText

class LevelPopView: UIView {
    
    let viewModel = LevelPopViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 269.uiX, height: 54.uiX)
        layout.minimumLineSpacing = 10.uiX
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(cellType: LevelPopCell.self)
        
        return collectionView
    }()
    
    init(song: SongModel) {
        let bgImg = UIImage.create("rw-bg-k")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
    
        let titleImg = UIImage.create("rw-bg")
        let titleImgView = UIImageView(image: titleImg)
        titleImgView.size = titleImg.snpSize
        titleImgView.y = 24.5.uiX
        titleImgView.x = (width - titleImgView.width)/2.0
        addSubview(titleImgView)
        
        let titleLbl = UILabel()
        titleLbl.width = 100.uiX
        titleLbl.height = 14.uiX
        titleLbl.y = 395.5.uiX
        titleLbl.x = 32.5.uiX
        addSubview(titleLbl)
        let att1 = NSMutableAttributedString(string: "当前")
        att1.yy_color = .init(hex: "#ffffff")
        att1.yy_font = .init(style: .regular, size: 14.uiX)
        let att2 = NSMutableAttributedString(string: "\(song.level ?? 0)")
        att2.yy_color = .init(hex: "#FEF284")
        att2.yy_font = .init(style: .regular, size: 14.uiX)
        let att3 = NSMutableAttributedString(string: "关")
        att3.yy_color = .init(hex: "#ffffff")
        att3.yy_font = .init(style: .regular, size: 14.uiX)
        att1.append(att2)
        att1.append(att3)
        titleLbl.attributedText = att1
        
        let closeImg = UIImage.create("choose_icon_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 14.uiX
        closeBtn.x = width - closeBtn.width - 13.uiX
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        addSubview(closeBtn)
        
        collectionView.width = 269.uiX
        collectionView.height = 310.uiX
        collectionView.y = 73.5.uiX
        collectionView.x = (width - collectionView.width)/2.0
        addSubview(collectionView)
        
        let input = LevelPopViewModel.Input(request: Observable<Int>.just(song.level))
        let output = viewModel.transform(input: input)
        
        output.list.bind(to: collectionView.rx.items(cellIdentifier: LevelPopCell.reuseIdentifier, cellType: LevelPopCell.self)) { (row, element, cell) in
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)
        
        output.openCoinSuccess.subscribe(onNext: { [weak self] m in
            guard let self = self else { return }
            self.showMsg(msg: "领取到\(m?.gold ?? 0)个金币")
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
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
