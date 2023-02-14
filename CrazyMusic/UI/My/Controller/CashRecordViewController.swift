//
//  CashRecordViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/13.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CashRecordViewController: ViewController {
    
    var viewModel: ListViewModel<CashRecordModel>!
    var tableView: UITableView!
    
    private let headerRefreshTrigger = PublishSubject<Void>()
    private let footerRefreshTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "提现记录"
        setupUI()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        setupBinding()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 95.uiX
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: GetCashTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        tableView.mj_header = RefreshHeader(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.headerRefreshTrigger.onNext(())
        })
        
        tableView.mj_footer = RefreshFooter(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.footerRefreshTrigger.onNext(())
        })
        tableView.mj_footer?.isHidden = true
    }
    
    private func setupBinding() {
        
        let input = ListViewModel<CashRecordModel>.Input(headerRefresh: Observable.merge(headerRefreshTrigger, errorBtnTap.asObservable().startWith(())),
                                        footerRefresh: footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(cellIdentifier: GetCashTableCell.reuseIdentifier, cellType: GetCashTableCell.self)) {collectionView, model, cell in
            cell.bind(to: model)
        }.disposed(by: rx.disposeBag)
        
        if let footer = tableView.mj_footer {
            output.footerLoading.bind(to: footer.rx.refreshStatus).disposed(by: rx.disposeBag)
        }
        if let header = tableView.mj_header {
            output.headerLoading.asObservable().bind(to: header.rx.isAnimating).disposed(by: rx.disposeBag)
        }
        
        output.firstLoading.distinctUntilChanged().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView(imageName: "message_defaultpage", title: "暂无记录")).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
    }
    
}
