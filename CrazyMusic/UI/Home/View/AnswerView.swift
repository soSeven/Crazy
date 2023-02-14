//
//  AnswerView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/7.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import Lottie

class AnswerView: UIView {
    
    let songViewModel: SongCellViewModel
    let contentView = UIView()
    let bgImgView = UIImageView()
    let textbgImgView = UIImageView()
    let deleteView = UIView()
    let textlbl = UILabel()

    init(viewModel: SongCellViewModel) {
        songViewModel = viewModel
        let frame: CGRect = .init(x: 0, y: 0, width: 248.uiX, height: 99.5.uiX)
        super.init(frame: frame)
        contentView.frame = bounds
        addSubview(contentView)
        
        let bgImg = UIImage.create("home_img_block")
        bgImgView.image = bgImg
        bgImgView.frame = contentView.bounds
        contentView.addSubview(bgImgView)
        
        let textbgImg = UIImage.create("correct_img_song_bgd1")
        textbgImgView.image = textbgImg
        textbgImgView.size = textbgImg.snpSize
        contentView.addSubview(textbgImgView)
        
        textlbl.text = songViewModel.text
        textlbl.textColor = .init(hex: "#FFFFFF")
        textlbl.font = .init(style: .medium, size: 18.uiX)
        textlbl.sizeToFit()
        textlbl.width = CGFloat.minimum(textbgImg.snpSize.width, textlbl.width)
        textlbl.height = 29.uiX
        textlbl.x = (contentView.width - textlbl.width)/2.0
        textlbl.y = (contentView.height - textlbl.height)/2.0
        textlbl.textAlignment = .center
        contentView.addSubview(textlbl)
        
        textbgImgView.center = textlbl.center
        textbgImgView.alpha = 0
        
        deleteView.backgroundColor = .init(hex: "#F21F60")
        deleteView.width = 0
        deleteView.height = 2.uiX
        deleteView.y = 29.uiX/2.0
        deleteView.x = -7.5.uiX
        textlbl.addSubview(deleteView)
        
        let selectedAnimation = Animation.named("data", subdirectory: "4")
        let selectedAnimationView = AnimationView(animation: selectedAnimation)
        selectedAnimationView.contentMode = .scaleAspectFill
        selectedAnimationView.width = self.contentView.width + 35.uiX
        selectedAnimationView.height = self.contentView.height + 10.uiX
        selectedAnimationView.center = self.contentView.center
        selectedAnimationView.loopMode = .loop
        selectedAnimationView.backgroundBehavior = .pauseAndRestore
        self.contentView.insertSubview(selectedAnimationView, at: 0)
        selectedAnimationView.isHidden = true
        
        let btn = MusicButton(frame: bounds)
        contentView.addSubview(btn)
        btn.addTarget(self, action: #selector(onClickDown), for: .touchDown)
        btn.addTarget(self, action: #selector(onClickUp), for: [.touchUpInside, .touchUpOutside])
        
        songViewModel.isShowCompletion.bind {[weak self] isShow in
            guard let self = self else { return }
            if isShow {
                if self.songViewModel.isRight {
                    if self.songViewModel.isShowSelected.value {
                        self.bgImgView.image = UIImage.create("wrong_img_block2")
                    } else {
                        self.bgImgView.image = UIImage.create("wrong_img_block1")
                    }
                } else {
                    if self.songViewModel.isShowSelected.value {
                        let animation = Animation.named("data", subdirectory: "1")
                        let animationView = AnimationView(animation: animation)
                        animationView.contentMode = .scaleAspectFill
                        animationView.width = self.contentView.width + 35.uiX
                        animationView.height = self.contentView.height + 10.uiX
                        animationView.center = self.contentView.center
                        animationView.loopMode = .loop
                        animationView.backgroundBehavior = .pauseAndRestore
                        self.contentView.insertSubview(animationView, at: 0)
                        animationView.play()
                        self.bgImgView.isHidden = true
                        self.bgImgView.image = UIImage.create("wrong_img_block3")
                        
                        selectedAnimationView.isHidden = true
                        selectedAnimationView.pause()
                    } else {
                        self.bgImgView.image = UIImage.create("wrong_img_block1")
                    }
                }
            } else {
                self.bgImgView.image = UIImage.create("home_img_block")
            }
        }.disposed(by: rx.disposeBag)
        
        songViewModel.isShowSelected.bind {[weak self] isShow in
            guard let self = self else { return }
            if isShow {
                self.bgImgView.image = UIImage.create("wrong_img_block2")
                self.bgImgView.isHidden = true
                self.textbgImgView.image = .create("correct_img_song_bgd2")
                selectedAnimationView.isHidden = false
                selectedAnimationView.play()
            } else {
                self.bgImgView.image = UIImage.create("home_img_block")
                self.bgImgView.isHidden = false
                self.textbgImgView.image = .create("correct_img_song_bgd1")
                selectedAnimationView.isHidden = true
                selectedAnimationView.pause()
            }
        }.disposed(by: rx.disposeBag)
        
        songViewModel.isShowLabelAnimation.bind {[weak self] isShow in
            guard let self = self else { return }
            if isShow {
                UIView.animate(withDuration: 0.25) {
                    self.textlbl.y =  60.5.uiX
                    self.textbgImgView.center = self.textlbl.center
                    self.textbgImgView.alpha = 1
                }
            }
        }.disposed(by: rx.disposeBag)
        
        if !songViewModel.isRight {
            songViewModel.isShowDelete.subscribe(onNext: {[weak self] isShow in
                guard let self = self else { return }
                if isShow {
                    UIView.animate(withDuration: 0.25) {
                        self.deleteView.width = self.textlbl.width + 15.uiX
                    }
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.deleteView.width = 0
                    }
                }
            }).disposed(by: rx.disposeBag)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func onClickDown() {
        UIView.animate(withDuration: 0.25) {
            self.contentView.transform = .init(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc
    func onClickUp() {
        UIView.animate(withDuration: 0.25) {
            self.contentView.transform = .identity
        }
        if songViewModel.isShowCompletion.value {
            return
        }
        songViewModel.selected.accept(songViewModel)
    }
    
}
