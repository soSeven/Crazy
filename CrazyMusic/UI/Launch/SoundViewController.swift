//
//  SoundViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/27.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit

class SoundViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let v = SoundProgressView()
        v.center = view.center
        view.addSubview(v)
        view.backgroundColor = .black
    }
    

}
