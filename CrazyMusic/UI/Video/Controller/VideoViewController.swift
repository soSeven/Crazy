//
//  VideoViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/11.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
//import YLUISDK

class VideoViewController: ViewController {
    
//    let video = YLLittleVideoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
//        let y: CGFloat = UIDevice.statusBarHeight
//        let height: CGFloat = UIDevice.screenHeight - y - tabBarController!.tabBar.height
//        video.view.frame = .init(x: 0, y: y, width: UIDevice.screenWidth, height: height)
//        view.addSubview(video.view)
//        addChild(video)
    }
    
//    override func onceWhenViewDidAppear(_ animated: Bool) {
//        self.video.pause()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            
//            self.video.play()
//        }
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
