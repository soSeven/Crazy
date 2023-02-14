//
//  HelpViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/19.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import YYText
import RxSwift
import RxCocoa

class HelpViewController: ViewController {
    
    let pub = PublishRelay<(String?, String?)>()
    
    var viewModel: HelpViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "意见反馈"
        setupUI()
        setupBinding()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func setupBinding() {
        
        let input = HelpViewModel.Input(request: pub.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: {[weak self] msg in
            guard let self = self else { return }
            if let view = UIApplication.shared.keyWindow {
                Observable.just(msg).bind(to: view.rx.toastText()).disposed(by: self.rx.disposeBag)
            }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
    }
    
    private func setupUI() {
        
        let lbl1 = UILabel()
        lbl1.text = "反馈内容"
        lbl1.textColor = .init(hex: "#333333")
        lbl1.font = .init(style: .regular, size: 15.uiX)
        view.addSubview(lbl1)
        lbl1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.top.equalToSuperview().offset(20.uiX)
        }
        
        let textView = YYTextView()
        textView.cornerRadius = 5.uiX
        textView.placeholderFont = .init(style: .regular, size: 14.uiX)
        textView.placeholderTextColor = .init(hex: "#999999")
        textView.placeholderText = "请描述您遇到的问题"
        textView.font = .init(style: .regular, size: 14.uiX)
        textView.textColor = .init(hex: "#333333")
        textView.backgroundColor = .init(hex: "#F5F5F5")
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.top.equalTo(lbl1.snp.bottom).offset(12.uiX)
            make.height.equalTo(147.uiX)
        }
        
        let lbl2 = UILabel()
        lbl2.text = "联系方式"
        lbl2.textColor = .init(hex: "#333333")
        lbl2.font = .init(style: .regular, size: 15.uiX)
        view.addSubview(lbl2)
        lbl2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.top.equalTo(textView.snp.bottom).offset(20.uiX)
        }
        
        let phoneView = UITextField()
        phoneView.backgroundColor = .init(hex: "#F5F5F5")
        phoneView.cornerRadius = 5.uiX
        phoneView.textColor = .init(hex: "#333333")
        phoneView.font = .init(style: .regular, size: 14.uiX)
        phoneView.attributedPlaceholder = .init(string: "QQ号/微信号/手机号", attributes: [
            .font : UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#999999")
        ])
        view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.top.equalTo(lbl2.snp.bottom).offset(12.uiX)
            make.height.equalTo(44.uiX)
        }
        
        let img = UIImage.create("tj")
        let btn = MusicButton()
        btn.setBackgroundImage(img, for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
            if textView.text.isEmpty {
                Observable.just("请填写反馈内容").bind(to: self.view.rx.toastText()).disposed(by: self.rx.disposeBag)
                return
            }
            if phoneView.text == nil {
                Observable.just("请填写联系方式").bind(to: self.view.rx.toastText()).disposed(by: self.rx.disposeBag)
                return
            }
            self.pub.accept((textView.text, phoneView.text))
        }).disposed(by: rx.disposeBag)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.size.equalTo(img.snpSize)
            make.top.equalTo(phoneView.snp.bottom).offset(36.uiX)
            make.centerX.equalToSuperview()
        }
        
    }

}
