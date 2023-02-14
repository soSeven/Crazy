//
//  WPTabBar.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/7.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift
import SnapKit

class WPTabBar: UITabBar {
    
    let bgViews = [
        UIImageView(image: UIImage(named: "tab_img_sel")),
        UIImageView(image: UIImage(named: "tab_img_sel")),
        UIImageView(image: UIImage(named: "tab_img_sel")),
        UIImageView(image: UIImage(named: "tab_img_sel")),
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgViews.forEach{ self.addSubview($0) }
        selectItem(at: 0)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = UIDevice.isPhoneX ? 34 + 57.uiX : 57.uiX
        return size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let tabBarButtonClass = NSClassFromString("UITabBarButton") {
            let items = subviews.filter { sub -> Bool in
                return sub.isKind(of: tabBarButtonClass)
            }
            
            for (idx, v) in items.enumerated() {
                if bgViews.count > idx {
                    bgViews[idx].frame = v.frame
                }
            }
        }
    }
    
    func selectItem(at index: Int) {
        bgViews.forEach{ $0.isHidden = true }
        if index < bgViews.count {
            bgViews[index].isHidden = false
        }
    }
    
    
    
}
